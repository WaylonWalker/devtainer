package main

import (
	"bufio"
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"io/fs"
	"math"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"sync"
	"time"

	toml "github.com/pelletier/go-toml/v2"
)

var version = "dev"

const (
	colorReset     = "\033[0m"
	colorAyuRed    = "\033[38;5;203m"
	colorAyuGreen  = "\033[38;5;150m"
	colorAyuYellow = "\033[38;5;221m"
	colorAyuBlue   = "\033[38;5;111m"
	colorAyuCyan   = "\033[38;5;116m"
	colorAyuGray   = "\033[38;5;246m"
)

type Config struct {
	ActiveProfile string             `toml:"active_profile"`
	Profiles      map[string]Profile `toml:"profiles"`
}

type Profile struct {
	SSHConfig          string `toml:"ssh_config"`
	SSHConfigItem      string `toml:"ssh_config_item"`
	SSHKey             string `toml:"ssh_key"`
	SSHKeyItem         string `toml:"ssh_key_item"`
	GitCredentials     string `toml:"git_credentials"`
	GitCredentialsItem string `toml:"git_credentials_item"`
	KubeConfig         string `toml:"kube_config"`
	KubeConfigItem     string `toml:"kube_config_item"`
	ArgoCDConfig       string `toml:"argocd_config"`
	ArgoCDConfigItem   string `toml:"argocd_config_item"`
}

type profileItemsView struct {
	SSHConfigItem      string `toml:"ssh_config_item"`
	SSHKeyItem         string `toml:"ssh_key_item"`
	GitCredentialsItem string `toml:"git_credentials_item"`
	KubeConfigItem     string `toml:"kube_config_item"`
	ArgoCDConfigItem   string `toml:"argocd_config_item"`
}

type configView struct {
	ActiveProfile string                      `toml:"active_profile"`
	Profiles      map[string]profileItemsView `toml:"profiles"`
}

type State struct {
	Targets map[string]TargetState `json:"targets"`
}

type TargetState struct {
	Profile    string `json:"profile"`
	Item       string `json:"item"`
	Path       string `json:"path"`
	Checksum   string `json:"checksum"`
	UpdatedAt  string `json:"updated_at"`
	Storage    string `json:"storage"`
	Resolution string `json:"resolution"`
}

type ManagedTarget struct {
	Tool        string
	Artifact    string
	DisplayName string
	DefaultPath string
	Mode        fs.FileMode
	ItemName    func(Profile) string
}

type bwStatus struct {
	Status string `json:"status"`
}

type bwItemSummary struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

type bwResolution struct {
	Ref         string
	ID          string
	Name        string
	Content     string
	StorageType string
	Item        map[string]any
}

type doctorPrefetch struct {
	resolutions map[string]*bwResolution
	errors      map[string]error
}

type spinner struct {
	message string
	done    chan struct{}
	wg      sync.WaitGroup
}

type doctorReport struct {
	Profile         string               `json:"profile"`
	BitwardenStatus string               `json:"bitwarden_status"`
	Targets         []doctorTargetResult `json:"targets"`
	Hints           []string             `json:"hints,omitempty"`
}

type doctorTargetResult struct {
	Tool             string `json:"tool"`
	Artifact         string `json:"artifact"`
	DisplayName      string `json:"display_name"`
	Profile          string `json:"profile"`
	Path             string `json:"path"`
	SelectedItem     string `json:"selected_item,omitempty"`
	LocalFileStatus  string `json:"local_file_status"`
	Permissions      string `json:"permissions"`
	BitwardenCompare string `json:"bitwarden_compare"`
	IssueKind        string `json:"issue_kind,omitempty"`
	LastApplied      string `json:"last_applied,omitempty"`
	Error            string `json:"error,omitempty"`
	Fixable          bool   `json:"fixable"`
}

var uuidPattern = regexp.MustCompile(`^[0-9a-fA-F-]{32,36}$`)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fmt.Fprintln(os.Stderr, normalizeError(err))
		os.Exit(1)
	}
}

func run(args []string) error {
	if len(args) == 0 {
		printRootHelp(os.Stdout)
		return nil
	}

	switch args[0] {
	case "-h", "--help", "help":
		printRootHelp(os.Stdout)
		return nil
	case "-v", "--version", "version":
		fmt.Fprintln(os.Stdout, version)
		return nil
	case "config":
		return runConfig(args[1:])
	case "profile":
		return runProfile(args[1:])
	case "setup":
		return runSetup(args[1:])
	case "bootstrap":
		return runBootstrap(args[1:])
	case "doctor", "checkhealth":
		return runDoctor(args[1:])
	case "update":
		return runUpdate(args[1:])
	default:
		return fmt.Errorf("unknown command %q\nRun `devtainer --help` for usage", args[0])
	}
}

func runConfig(args []string) error {
	if len(args) == 0 {
		printConfigHelp(os.Stdout)
		return nil
	}

	switch args[0] {
	case "path":
		fmt.Fprintln(os.Stdout, configPath())
		return nil
	case "init":
		fs := flag.NewFlagSet("config init", flag.ContinueOnError)
		fs.SetOutput(io.Discard)
		profile := fs.String("profile", "personal", "Initial profile name")
		force := fs.Bool("force", false, "Overwrite an existing config")
		if err := fs.Parse(args[1:]); err != nil {
			return err
		}
		return initConfig(*profile, *force)
	case "show":
		cfg, _, err := loadConfig()
		if err != nil {
			return err
		}
		payload, err := toml.Marshal(configToView(cfg))
		if err != nil {
			return err
		}
		_, err = os.Stdout.Write(payload)
		return err
	default:
		return fmt.Errorf("unknown config command %q", args[0])
	}

}

func runProfile(args []string) error {
	if len(args) == 0 {
		printProfileHelp(os.Stdout)
		return nil
	}

	switch args[0] {
	case "list":
		cfg, _, err := loadConfig()
		if err != nil {
			return err
		}
		names := make([]string, 0, len(cfg.Profiles))
		for name := range cfg.Profiles {
			names = append(names, name)
		}
		sort.Strings(names)
		for _, name := range names {
			marker := " "
			if name == cfg.ActiveProfile {
				marker = "*"
			}
			fmt.Fprintf(os.Stdout, "%s %s\n", marker, name)
		}
		return nil
	case "show":
		cfg, profileName, profile, err := loadSelectedProfile("")
		if err != nil {
			return err
		}
		fmt.Fprintf(os.Stdout, "active_profile = %q\n", profileName)
		fmt.Fprintf(os.Stdout, "ssh_config_item = %q\n", profile.SSHConfig)
		fmt.Fprintf(os.Stdout, "ssh_key_item = %q\n", profile.SSHKey)
		fmt.Fprintf(os.Stdout, "git_credentials_item = %q\n", profile.GitCredentials)
		fmt.Fprintf(os.Stdout, "kube_config_item = %q\n", profile.KubeConfig)
		fmt.Fprintf(os.Stdout, "argocd_config_item = %q\n", profile.ArgoCDConfig)
		_ = cfg
		return nil
	case "use":
		if len(args) < 2 {
			return errors.New("usage: devtainer profile use <name>")
		}
		return setActiveProfile(args[1])
	case "add":
		fs := flag.NewFlagSet("profile add", flag.ContinueOnError)
		fs.SetOutput(io.Discard)
		clone := fs.String("clone", "", "Clone values from an existing profile")
		if err := fs.Parse(args[1:]); err != nil {
			return err
		}
		remaining := fs.Args()
		if len(remaining) != 1 {
			return errors.New("usage: devtainer profile add <name> [--clone existing]")
		}
		return addProfile(remaining[0], *clone)
	case "set-item":
		if len(args) != 4 {
			return errors.New("usage: devtainer profile set-item <profile> <slot> <bitwarden-item>")
		}
		return setProfileItem(args[1], args[2], args[3])
	default:
		return fmt.Errorf("unknown profile command %q", args[0])
	}
}

func runSetup(args []string) error {
	fs := flag.NewFlagSet("setup", flag.ContinueOnError)
	fs.SetOutput(io.Discard)
	profileOverride := fs.String("profile", "", "Profile override")
	if err := fs.Parse(args); err != nil {
		return err
	}
	remaining := fs.Args()
	if len(remaining) == 0 {
		return errors.New("usage: devtainer setup <ssh|git|kube|argocd|all>")
	}

	_, profileName, profile, err := loadSelectedProfile(*profileOverride)
	if err != nil {
		return err
	}
	spin := startSpinner("Checking Bitwarden session")
	err = requireBWUnlocked()
	spin.Stop(err)
	if err != nil {
		return err
	}

	targets, err := targetsForTool(remaining[0], profile)
	if err != nil {
		return err
	}
	state, _ := loadState()
	for _, target := range targets {
		if err := applyTarget(state, profileName, target); err != nil {
			return err
		}
	}
	return saveState(state)
}

func runBootstrap(args []string) error {
	if len(args) == 0 {
		return errors.New("usage: devtainer bootstrap bitwarden [ssh|git|kube|all]")
	}
	if args[0] != "bitwarden" {
		return fmt.Errorf("unknown bootstrap target %q", args[0])
	}

	fs := flag.NewFlagSet("bootstrap bitwarden", flag.ContinueOnError)
	fs.SetOutput(io.Discard)
	profileOverride := fs.String("profile", "", "Profile override")
	if err := fs.Parse(args[1:]); err != nil {
		return err
	}
	remaining := fs.Args()
	tool := "all"
	if len(remaining) > 0 {
		tool = remaining[0]
	}

	_, profileName, profile, err := loadSelectedProfile(*profileOverride)
	if err != nil {
		return err
	}
	spin := startSpinner("Checking Bitwarden session")
	err = requireBWUnlocked()
	spin.Stop(err)
	if err != nil {
		return err
	}
	targets, err := targetsForTool(tool, profile)
	if err != nil {
		return err
	}
	created := 0
	skipped := 0
	for _, target := range targets {
		createdTarget, err := bootstrapTarget(profileName, target)
		if err != nil {
			return err
		}
		if createdTarget {
			created++
		} else {
			skipped++
		}
	}
	fmt.Fprintf(os.Stdout, "\n%s created=%d skipped=%d\n", statusLabel("ok", "bootstrap"), created, skipped)
	return nil
}

func runDoctor(args []string) error {
	fs := flag.NewFlagSet("doctor", flag.ContinueOnError)
	fs.SetOutput(io.Discard)
	profileOverride := fs.String("profile", "", "Profile override")
	verbose := fs.Bool("verbose", false, "Show more detail for mismatches")
	fix := fs.Bool("fix", false, "Fix safe local issues like file permissions")
	jsonOutput := fs.Bool("json", false, "Emit structured JSON output")
	if err := fs.Parse(args); err != nil {
		return err
	}
	remaining := fs.Args()
	tool := "all"
	if len(remaining) > 0 {
		tool = remaining[0]
	}

	_, profileName, profile, err := loadSelectedProfile(*profileOverride)
	if err != nil {
		return err
	}
	targets, err := targetsForTool(tool, profile)
	if err != nil {
		return err
	}

	spin := startSpinner("Checking Bitwarden session")
	status, statusErr := getBWStatus()
	spin.Stop(statusErr)

	failures := 0
	fixableFailures := 0
	missingItemFailures := 0
	compareFailures := 0
	missingFileFailures := 0
	state, _ := loadState()
	prefetch := doctorPrefetch{resolutions: map[string]*bwResolution{}, errors: map[string]error{}}
	report := doctorReport{Profile: profileName, BitwardenStatus: status, Targets: make([]doctorTargetResult, 0, len(targets))}
	if status == "unlocked" {
		spin = startSpinner("Loading Bitwarden items")
		prefetch = prefetchDoctorItems(profile, targets)
		spin.Stop(nil)
	}
	for _, target := range targets {
		result := doctorTarget(state, profileName, profile, target, status == "unlocked", *fix, prefetch)
		report.Targets = append(report.Targets, result)
		if result.Error != "" {
			failures++
		}
		if result.Fixable {
			fixableFailures++
		}
		switch result.IssueKind {
		case "missing_item":
			missingItemFailures++
		case "compare_failed", "content_differs":
			compareFailures++
		case "missing_file":
			missingFileFailures++
		}
	}
	if fixableFailures > 0 && !*fix {
		report.Hints = append(report.Hints, "Run `devtainer doctor --fix` to repair safe local issues like permissions. It will not unlock Bitwarden or overwrite file contents.")
	}
	if status == "unlocked" && missingItemFailures > 0 {
		report.Hints = append(report.Hints, "Bitwarden is unlocked, but one or more selected items do not exist. Run `devtainer bootstrap bitwarden` to seed the expected canonical items and timestamped history from your current local files, or use `devtainer profile set-item <profile> <slot> <bitwarden-item>` to point at existing items.")
	}
	if status == "unlocked" && missingFileFailures > 0 && missingItemFailures == 0 {
		report.Hints = append(report.Hints, "One or more managed files are missing locally. Run `devtainer setup all` or `devtainer setup <tool>` to materialize them from Bitwarden.")
	}
	if status == "unlocked" && compareFailures > 0 && missingItemFailures == 0 {
		report.Hints = append(report.Hints, "One or more local files differ from Bitwarden. Review with `devtainer doctor --verbose`, then use `devtainer update <tool>` to promote local changes or `devtainer setup <tool>` to restore from Bitwarden.")
	}
	if statusErr != nil {
		report.Hints = append(report.Hints, statusErr.Error())
	}
	if status == "locked" {
		report.Hints = append(report.Hints, "Run bw unlock, then re-run devtainer doctor.")
	}
	if status == "unauthenticated" {
		report.Hints = append(report.Hints, "Run bw login, then bw unlock.")
	}
	if *jsonOutput {
		payload, err := json.MarshalIndent(report, "", "  ")
		if err != nil {
			return err
		}
		fmt.Fprintln(os.Stdout, string(payload))
	} else {
		renderDoctorReport(os.Stdout, report, *verbose)
	}
	if failures > 0 || statusErr != nil || status != "unlocked" {
		return errors.New("doctor found issues")
	}
	return nil
}

func runUpdate(args []string) error {
	fs := flag.NewFlagSet("update", flag.ContinueOnError)
	fs.SetOutput(io.Discard)
	profileOverride := fs.String("profile", "", "Profile override")
	fromFile := fs.String("from-file", "", "Source file to promote into Bitwarden")
	yes := fs.Bool("yes", false, "Skip confirmation prompt")
	artifact := fs.String("artifact", "", "Artifact name for multi-file tools like ssh (config or key)")
	if err := fs.Parse(args); err != nil {
		return err
	}
	remaining := fs.Args()
	if len(remaining) == 0 {
		return errors.New("usage: devtainer update <ssh|git|kube|argocd>")
	}

	_, profileName, profile, err := loadSelectedProfile(*profileOverride)
	if err != nil {
		return err
	}
	spin := startSpinner("Checking Bitwarden session")
	err = requireBWUnlocked()
	spin.Stop(err)
	if err != nil {
		return err
	}
	target, err := targetForUpdate(remaining[0], profile, *artifact)
	if err != nil {
		return err
	}

	path := *fromFile
	if path == "" {
		path = target.DefaultPath
		fmt.Fprintf(os.Stderr, "Using default path %s for %s\n", path, target.DisplayName)
	}
	resolvedPath, err := expandPath(path)
	if err != nil {
		return err
	}
	contentBytes, err := os.ReadFile(resolvedPath)
	if err != nil {
		return fmt.Errorf("read %s: %w", resolvedPath, err)
	}
	localContent := string(contentBytes)
	resolution, err := resolveBWItem(target.ItemName(profile))
	if err != nil {
		return err
	}
	if resolution.Content == localContent {
		fmt.Fprintf(os.Stdout, "%s is already in sync with %s\n", target.DisplayName, resolution.Name)
		return nil
	}

	showDiffSummary(target, resolution.Content, localContent)
	confirmed, err := confirmAction(*yes, fmt.Sprintf("Update %s from %s?", resolution.Name, resolvedPath))
	if err != nil {
		return err
	}
	if !confirmed {
		fmt.Fprintln(os.Stdout, "Update cancelled")
		return nil
	}
	if err := snapshotBWItem(target, resolution); err != nil {
		return err
	}
	if err := updateBWItem(resolution, localContent); err != nil {
		return err
	}

	state, _ := loadState()
	recordTargetState(state, profileName, target, resolution.Ref, resolvedPath, localContent, resolution.StorageType)
	if err := saveState(state); err != nil {
		return err
	}
	fmt.Fprintf(os.Stdout, "Updated %s from %s\n", resolution.Name, resolvedPath)
	return nil
}

func applyTarget(state *State, profileName string, target ManagedTarget) error {
	itemRef := target.ItemName(loadProfileForState(profileName))
	if itemRef == "" {
		fmt.Fprintf(os.Stdout, "%s %s for profile %s\n", statusLabel("warn", "skip"), colorize(colorAyuGray, "No Bitwarden item configured for"), profileName)
		return nil
	}
	resolution, err := resolveBWItem(itemRef)
	if err != nil {
		return fmt.Errorf("resolve %s: %w", target.DisplayName, err)
	}
	path, err := expandPath(target.DefaultPath)
	if err != nil {
		return err
	}
	if err := os.MkdirAll(filepath.Dir(path), 0o700); err != nil {
		return fmt.Errorf("create parent directory for %s: %w", path, err)
	}
	current, err := os.ReadFile(path)
	if err == nil && string(current) == resolution.Content {
		if chmodErr := os.Chmod(path, target.Mode); chmodErr == nil {
			recordTargetState(state, profileName, target, resolution.Ref, path, resolution.Content, resolution.StorageType)
		}
		fmt.Fprintf(os.Stdout, "%s %s %s\n", statusLabel("ok", "ok"), target.DisplayName, colorize(colorAyuGray, path))
		return nil
	}
	if err != nil && !errors.Is(err, os.ErrNotExist) {
		return fmt.Errorf("read %s: %w", path, err)
	}
	if err := os.WriteFile(path, []byte(resolution.Content), target.Mode); err != nil {
		return fmt.Errorf("write %s: %w", path, err)
	}
	recordTargetState(state, profileName, target, resolution.Ref, path, resolution.Content, resolution.StorageType)
	fmt.Fprintf(os.Stdout, "%s %s -> %s\n", statusLabel("ok", "wrote"), target.DisplayName, colorize(colorAyuGray, path))
	return nil
}

func bootstrapTarget(profileName string, target ManagedTarget) (bool, error) {
	itemRef := target.ItemName(loadProfileForState(profileName))
	if itemRef == "" {
		fmt.Fprintf(os.Stdout, "%s %s profile %s\n", statusLabel("warn", "skip"), colorize(colorAyuGray, "No Bitwarden item configured for"), profileName)
		return false, nil
	}
	path, err := expandPath(target.DefaultPath)
	if err != nil {
		return false, err
	}
	contentBytes, err := os.ReadFile(path)
	if err != nil {
		return false, fmt.Errorf("read %s: %w", path, err)
	}
	content := string(contentBytes)
	resolution, err := resolveBWItem(itemRef)
	if err == nil {
		if resolution.Content == content {
			fmt.Fprintf(os.Stdout, "%s %s already exists as %s\n", statusLabel("ok", "exists"), target.DisplayName, colorize(colorAyuGray, itemRef))
			return false, nil
		}
		fmt.Fprintf(os.Stdout, "%s %s exists but differs from %s. Use %s to promote the local file.\n", statusLabel("warn", "skip"), target.DisplayName, colorize(colorAyuGray, itemRef), colorize(colorAyuBlue, bootstrapUpdateHint(target)))
		return false, nil
	}
	if !strings.Contains(err.Error(), "no Bitwarden item named") {
		return false, err
	}
	if err := createBWItem(itemRef, content); err != nil {
		return false, err
	}
	if err := createSnapshotContent(target, content); err != nil {
		return false, err
	}
	fmt.Fprintf(os.Stdout, "%s %s -> %s and history snapshot\n", statusLabel("ok", "created"), target.DisplayName, colorize(colorAyuGray, itemRef))
	return true, nil
}

func doctorTarget(state *State, profileName string, profile Profile, target ManagedTarget, bwReady bool, fix bool, prefetch doctorPrefetch) doctorTargetResult {
	result := doctorTargetResult{
		Tool:            target.Tool,
		Artifact:        target.Artifact,
		DisplayName:     target.DisplayName,
		Profile:         profileName,
		Permissions:     "unknown",
		IssueKind:       "ok",
		LocalFileStatus: "present",
	}
	path, err := expandPath(target.DefaultPath)
	result.Path = path
	if err != nil {
		result.Error = err.Error()
		result.IssueKind = "path_error"
		return result
	}
	itemRef := target.ItemName(profile)
	result.SelectedItem = itemRef
	if itemRef == "" {
		result.IssueKind = "not_configured"
		return result
	}

	content, readErr := os.ReadFile(path)
	if readErr != nil {
		result.Error = readErr.Error()
		result.IssueKind = "missing_file"
		result.LocalFileStatus = "missing"
		return result
	}
	info, err := os.Stat(path)
	if err != nil {
		result.Error = err.Error()
		result.IssueKind = "stat_error"
		return result
	}
	actualMode := info.Mode().Perm()
	modeStatus := "ok"
	permissionMismatch := actualMode != target.Mode
	result.Fixable = permissionMismatch
	if actualMode != target.Mode {
		if fix {
			if err := os.Chmod(path, target.Mode); err != nil {
				modeStatus = fmt.Sprintf("failed to fix permissions: %s", err)
				result.Error = err.Error()
			} else {
				actualMode = target.Mode
				permissionMismatch = false
				modeStatus = fmt.Sprintf("fixed to %04o", target.Mode)
			}
		} else {
			modeStatus = fmt.Sprintf("expected %04o got %04o", target.Mode, actualMode)
		}
	}
	result.Permissions = modeStatus

	key := stateKey(profileName, target)
	if state != nil {
		if existing, ok := state.Targets[key]; ok {
			result.LastApplied = existing.UpdatedAt
		}
	}

	if !bwReady {
		result.BitwardenCompare = "unavailable"
		if permissionMismatch {
			result.Error = "permission mismatch"
			result.IssueKind = "permission_mismatch"
		}
		return result
	}

	resolution, err := resolveDoctorItem(prefetch, itemRef)
	if err != nil {
		result.Error = err.Error()
		result.BitwardenCompare = "failed"
		if strings.Contains(err.Error(), "no Bitwarden item named") {
			result.IssueKind = "missing_item"
			return result
		}
		result.IssueKind = "compare_failed"
		return result
	}
	if resolution.Content == string(content) {
		result.BitwardenCompare = "in_sync"
		if permissionMismatch {
			result.Error = "permission mismatch"
			result.IssueKind = "permission_mismatch"
		}
		return result
	}
	result.BitwardenCompare = "differs"
	result.Error = "content differs"
	result.IssueKind = "content_differs"
	return result
}

func prefetchDoctorItems(profile Profile, targets []ManagedTarget) doctorPrefetch {
	prefetch := doctorPrefetch{resolutions: map[string]*bwResolution{}, errors: map[string]error{}}
	refs := uniqueItemRefs(profile, targets)
	if len(refs) == 0 {
		return prefetch
	}
	index, err := listBWItemIndex()
	if err != nil {
		for _, ref := range refs {
			prefetch.errors[ref] = err
		}
		return prefetch
	}
	type result struct {
		ref        string
		resolution *bwResolution
		err        error
	}
	results := make(chan result, len(refs))
	started := 0
	for _, ref := range refs {
		id, ok := index[ref]
		if !ok {
			prefetch.errors[ref] = fmt.Errorf("no Bitwarden item named %q", ref)
			continue
		}
		started++
		go func(ref string, id string) {
			resolution, err := getBWItem(id, ref)
			results <- result{ref: ref, resolution: resolution, err: err}
		}(ref, id)
	}
	for i := 0; i < started; i++ {
		result := <-results
		if result.ref == "" {
			continue
		}
		if result.err != nil {
			prefetch.errors[result.ref] = result.err
			continue
		}
		prefetch.resolutions[result.ref] = result.resolution
	}
	return prefetch
}

func uniqueItemRefs(profile Profile, targets []ManagedTarget) []string {
	seen := map[string]bool{}
	refs := make([]string, 0, len(targets))
	for _, target := range targets {
		ref := target.ItemName(profile)
		if ref == "" || seen[ref] {
			continue
		}
		seen[ref] = true
		refs = append(refs, ref)
	}
	return refs
}

func listBWItemIndex() (map[string]string, error) {
	out, err := runCommand("bw", nil, "list", "items")
	if err != nil {
		return nil, fmt.Errorf("list Bitwarden items: %w", err)
	}
	var summaries []bwItemSummary
	if err := json.Unmarshal(out, &summaries); err != nil {
		return nil, err
	}
	index := make(map[string]string, len(summaries))
	for _, summary := range summaries {
		if _, exists := index[summary.Name]; !exists {
			index[summary.Name] = summary.ID
		}
	}
	return index, nil
}

func resolveDoctorItem(prefetch doctorPrefetch, ref string) (*bwResolution, error) {
	if resolution, ok := prefetch.resolutions[ref]; ok {
		return resolution, nil
	}
	if err, ok := prefetch.errors[ref]; ok {
		return nil, err
	}
	return resolveBWItem(ref)
}

func configPath() string {
	home, err := os.UserHomeDir()
	if err != nil {
		return ".config/devtainer/config.toml"
	}
	return filepath.Join(home, ".config", "devtainer", "config.toml")
}

func statePath() string {
	home, err := os.UserHomeDir()
	if err != nil {
		return ".local/state/devtainer/state.json"
	}
	return filepath.Join(home, ".local", "state", "devtainer", "state.json")
}

func initConfig(profile string, force bool) error {
	path := configPath()
	if !force {
		if _, err := os.Stat(path); err == nil {
			return fmt.Errorf("config already exists at %s; pass --force to overwrite", path)
		}
	}
	if err := os.MkdirAll(filepath.Dir(path), 0o700); err != nil {
		return err
	}
	cfg := Config{
		ActiveProfile: profile,
		Profiles: map[string]Profile{
			profile: {
				SSHConfig:      fmt.Sprintf("devtainer/ssh/config/%s", profile),
				SSHKey:         fmt.Sprintf("devtainer/ssh/id_ed25519/%s", profile),
				GitCredentials: fmt.Sprintf("devtainer/git/credentials/%s", profile),
				KubeConfig:     fmt.Sprintf("devtainer/kube/config/%s", profile),
				ArgoCDConfig:   fmt.Sprintf("devtainer/argocd/config/%s", profile),
			},
		},
	}
	content, err := toml.Marshal(cfg)
	if err != nil {
		return err
	}
	if err := os.WriteFile(path, content, 0o600); err != nil {
		return err
	}
	fmt.Fprintf(os.Stdout, "Wrote starter config to %s\n", path)
	return nil
}

func loadConfig() (*Config, string, error) {
	path := configPath()
	content, err := os.ReadFile(path)
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return nil, path, fmt.Errorf("config missing at %s\nRun `devtainer config init --profile personal` to create one", path)
		}
		return nil, path, err
	}
	var cfg Config
	if err := toml.Unmarshal(content, &cfg); err != nil {
		return nil, path, fmt.Errorf("parse %s: %w", path, err)
	}
	if cfg.ActiveProfile == "" {
		return nil, path, fmt.Errorf("config %s is missing active_profile", path)
	}
	if len(cfg.Profiles) == 0 {
		return nil, path, fmt.Errorf("config %s has no profiles", path)
	}
	applyProfileDefaults(&cfg)
	return &cfg, path, nil
}

func loadSelectedProfile(override string) (*Config, string, Profile, error) {
	cfg, _, err := loadConfig()
	if err != nil {
		return nil, "", Profile{}, err
	}
	profileName := cfg.ActiveProfile
	if override != "" {
		profileName = override
	}
	profile, ok := cfg.Profiles[profileName]
	if !ok {
		return nil, "", Profile{}, fmt.Errorf("profile %q not found in %s", profileName, configPath())
	}
	return cfg, profileName, profile, nil
}

func setActiveProfile(name string) error {
	cfg, path, err := loadConfig()
	if err != nil {
		return err
	}
	if _, ok := cfg.Profiles[name]; !ok {
		return fmt.Errorf("profile %q not found", name)
	}
	cfg.ActiveProfile = name
	content, err := toml.Marshal(cfg)
	if err != nil {
		return err
	}
	if err := os.WriteFile(path, content, 0o600); err != nil {
		return err
	}
	fmt.Fprintf(os.Stdout, "Active profile set to %s\n", name)
	return nil
}

func addProfile(name, clone string) error {
	cfg, path, err := loadConfig()
	if err != nil {
		return err
	}
	if _, ok := cfg.Profiles[name]; ok {
		return fmt.Errorf("profile %q already exists", name)
	}
	profile := defaultProfile(name)
	if clone != "" {
		clonedProfile, ok := cfg.Profiles[clone]
		if !ok {
			return fmt.Errorf("profile %q not found", clone)
		}
		profile = clonedProfile
	}
	if cfg.Profiles == nil {
		cfg.Profiles = map[string]Profile{}
	}
	cfg.Profiles[name] = profile
	content, err := toml.Marshal(cfg)
	if err != nil {
		return err
	}
	if err := os.WriteFile(path, content, 0o600); err != nil {
		return err
	}
	fmt.Fprintf(os.Stdout, "Added profile %s\n", name)
	return nil
}

func setProfileItem(name, slot, item string) error {
	cfg, path, err := loadConfig()
	if err != nil {
		return err
	}
	profile, ok := cfg.Profiles[name]
	if !ok {
		return fmt.Errorf("profile %q not found", name)
	}
	switch slot {
	case "ssh-config":
		profile.SSHConfig = item
	case "ssh-key":
		profile.SSHKey = item
	case "git-credentials":
		profile.GitCredentials = item
	case "kube-config":
		profile.KubeConfig = item
	case "argocd-config":
		profile.ArgoCDConfig = item
	default:
		return fmt.Errorf("unknown slot %q; expected ssh-config, ssh-key, git-credentials, kube-config, or argocd-config", slot)
	}
	cfg.Profiles[name] = profile
	content, err := toml.Marshal(cfg)
	if err != nil {
		return err
	}
	if err := os.WriteFile(path, content, 0o600); err != nil {
		return err
	}
	fmt.Fprintf(os.Stdout, "Set %s for profile %s to %s\n", slot, name, item)
	return nil
}

func loadState() (*State, error) {
	path := statePath()
	content, err := os.ReadFile(path)
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return &State{Targets: map[string]TargetState{}}, nil
		}
		return nil, err
	}
	var state State
	if err := json.Unmarshal(content, &state); err != nil {
		return nil, err
	}
	if state.Targets == nil {
		state.Targets = map[string]TargetState{}
	}
	return &state, nil
}

func saveState(state *State) error {
	path := statePath()
	if err := os.MkdirAll(filepath.Dir(path), 0o700); err != nil {
		return err
	}
	payload, err := json.MarshalIndent(state, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(path, payload, 0o600)
}

func recordTargetState(state *State, profile string, target ManagedTarget, item, path, content, storage string) {
	if state.Targets == nil {
		state.Targets = map[string]TargetState{}
	}
	state.Targets[stateKey(profile, target)] = TargetState{
		Profile:    profile,
		Item:       item,
		Path:       path,
		Checksum:   checksum(content),
		UpdatedAt:  time.Now().UTC().Format(time.RFC3339),
		Storage:    storage,
		Resolution: item,
	}
}

func stateKey(profile string, target ManagedTarget) string {
	return profile + ":" + target.Tool + ":" + target.Artifact
}

func targetsForTool(tool string, profile Profile) ([]ManagedTarget, error) {
	all := allTargets(profile)
	switch tool {
	case "all":
		return all, nil
	case "ssh", "git", "kube", "argocd":
		result := make([]ManagedTarget, 0, 2)
		for _, target := range all {
			if target.Tool == tool {
				result = append(result, target)
			}
		}
		return result, nil
	default:
		return nil, fmt.Errorf("unsupported tool %q", tool)
	}
}

func targetForUpdate(tool string, profile Profile, artifact string) (ManagedTarget, error) {
	targets, err := targetsForTool(tool, profile)
	if err != nil {
		return ManagedTarget{}, err
	}
	if tool == "ssh" {
		wanted := artifact
		if wanted == "" {
			wanted = "config"
		}
		for _, target := range targets {
			if target.Artifact == wanted {
				return target, nil
			}
		}
		return ManagedTarget{}, fmt.Errorf("unknown ssh artifact %q; expected config or key", wanted)
	}
	return targets[0], nil
}

func allTargets(profile Profile) []ManagedTarget {
	return []ManagedTarget{
		{
			Tool:        "ssh",
			Artifact:    "config",
			DisplayName: "ssh config",
			DefaultPath: "~/.ssh/config",
			Mode:        0o600,
			ItemName:    func(p Profile) string { return p.SSHConfig },
		},
		{
			Tool:        "ssh",
			Artifact:    "key",
			DisplayName: "ssh primary key",
			DefaultPath: "~/.ssh/id_ed25519",
			Mode:        0o600,
			ItemName:    func(p Profile) string { return p.SSHKey },
		},
		{
			Tool:        "git",
			Artifact:    "credentials",
			DisplayName: "git credentials",
			DefaultPath: "~/.git-credentials",
			Mode:        0o600,
			ItemName:    func(p Profile) string { return p.GitCredentials },
		},
		{
			Tool:        "kube",
			Artifact:    "config",
			DisplayName: "kube config",
			DefaultPath: "~/.kube/config",
			Mode:        0o600,
			ItemName:    func(p Profile) string { return p.KubeConfig },
		},
		{
			Tool:        "argocd",
			Artifact:    "config",
			DisplayName: "argocd config",
			DefaultPath: "~/.config/argocd/config",
			Mode:        0o600,
			ItemName:    func(p Profile) string { return p.ArgoCDConfig },
		},
	}
}

func requireBWUnlocked() error {
	status, err := getBWStatus()
	if err != nil {
		return err
	}
	if status != "unlocked" {
		return fmt.Errorf("bitwarden is %s\nUnlock it first with `bw unlock` or set BW_SESSION", status)
	}
	return nil
}

func getBWStatus() (string, error) {
	out, err := runCommand("bw", nil, "status")
	if err != nil {
		return "unavailable", fmt.Errorf("run `bw status`: %w", err)
	}
	var status bwStatus
	if err := json.Unmarshal(out, &status); err != nil {
		return "unavailable", fmt.Errorf("parse `bw status`: %w", err)
	}
	return status.Status, nil
}

func resolveBWItem(ref string) (*bwResolution, error) {
	if ref == "" {
		return nil, errors.New("empty Bitwarden item reference")
	}
	if uuidPattern.MatchString(ref) {
		return getBWItem(ref, ref)
	}
	summaries, err := searchBWItems(ref)
	if err != nil {
		return nil, err
	}
	matches := make([]bwItemSummary, 0, len(summaries))
	for _, summary := range summaries {
		if summary.Name == ref {
			matches = append(matches, summary)
		}
	}
	if len(matches) == 0 {
		return nil, fmt.Errorf("no Bitwarden item named %q", ref)
	}
	if len(matches) > 1 {
		return nil, fmt.Errorf("multiple Bitwarden items named %q; use an item id instead", ref)
	}
	return getBWItem(matches[0].ID, ref)
}

func searchBWItems(ref string) ([]bwItemSummary, error) {
	out, err := runCommand("bw", nil, "list", "items", "--search", ref)
	if err != nil {
		return nil, fmt.Errorf("search Bitwarden items for %q: %w", ref, err)
	}
	var summaries []bwItemSummary
	if err := json.Unmarshal(out, &summaries); err != nil {
		return nil, err
	}
	return summaries, nil
}

func getBWItem(id, ref string) (*bwResolution, error) {
	out, err := runCommand("bw", nil, "get", "item", id)
	if err != nil {
		return nil, fmt.Errorf("get Bitwarden item %q: %w", id, err)
	}
	var item map[string]any
	if err := json.Unmarshal(out, &item); err != nil {
		return nil, err
	}
	content, storage := extractBWContent(item)
	return &bwResolution{
		Ref:         ref,
		ID:          id,
		Name:        stringValue(item["name"]),
		Content:     content,
		StorageType: storage,
		Item:        item,
	}, nil
}

func extractBWContent(item map[string]any) (string, string) {
	if notes := stringValue(item["notes"]); notes != "" {
		return notes, "notes"
	}
	if login, ok := item["login"].(map[string]any); ok {
		if password := stringValue(login["password"]); password != "" {
			return password, "login_password"
		}
	}
	if fields, ok := item["fields"].([]any); ok {
		for _, field := range fields {
			fieldMap, ok := field.(map[string]any)
			if !ok {
				continue
			}
			name := strings.ToLower(stringValue(fieldMap["name"]))
			if name == "content" || name == "value" {
				return stringValue(fieldMap["value"]), "field"
			}
		}
	}
	return "", "notes"
}

func updateBWItem(resolution *bwResolution, content string) error {
	item := resolution.Item
	setBWContent(item, resolution.StorageType, content)
	payload, err := json.Marshal(item)
	if err != nil {
		return err
	}
	encoded, err := encodeForBW(payload)
	if err != nil {
		return err
	}
	_, err = runCommand("bw", nil, "edit", "item", resolution.ID, encoded)
	return err
}

func setBWContent(item map[string]any, storage string, content string) {
	switch storage {
	case "login_password":
		login, _ := item["login"].(map[string]any)
		if login == nil {
			login = map[string]any{}
		}
		login["password"] = content
		item["login"] = login
	case "field":
		fields, _ := item["fields"].([]any)
		for idx, field := range fields {
			fieldMap, ok := field.(map[string]any)
			if !ok {
				continue
			}
			name := strings.ToLower(stringValue(fieldMap["name"]))
			if name == "content" || name == "value" {
				fieldMap["value"] = content
				fields[idx] = fieldMap
				item["fields"] = fields
				return
			}
		}
		item["notes"] = content
	default:
		item["notes"] = content
	}
}

func snapshotBWItem(target ManagedTarget, resolution *bwResolution) error {
	return createNamedSecureNote(fmt.Sprintf("devtainer/history/%s/%s/%s", target.Tool, target.Artifact, time.Now().UTC().Format("2006-01-02T150405Z")), resolution.Content)
}

func createSnapshotContent(target ManagedTarget, content string) error {
	return createNamedSecureNote(fmt.Sprintf("devtainer/history/%s/%s/%s", target.Tool, target.Artifact, time.Now().UTC().Format("2006-01-02T150405Z")), content)
}

func createBWItem(name, content string) error {
	return createNamedSecureNote(name, content)
}

func createNamedSecureNote(name, content string) error {
	templateOut, err := runCommand("bw", nil, "get", "template", "item")
	if err != nil {
		return fmt.Errorf("get Bitwarden item template: %w", err)
	}
	var snapshot map[string]any
	if err := json.Unmarshal(templateOut, &snapshot); err != nil {
		return err
	}
	snapshot["type"] = 2
	snapshot["secureNote"] = map[string]any{"type": 0}
	snapshot["name"] = name
	snapshot["notes"] = content
	payload, err := json.Marshal(snapshot)
	if err != nil {
		return err
	}
	encoded, err := encodeForBW(payload)
	if err != nil {
		return err
	}
	_, err = runCommand("bw", nil, "create", "item", encoded)
	if err != nil {
		return fmt.Errorf("create Bitwarden item %q: %w", name, err)
	}
	return nil
}

func encodeForBW(payload []byte) (string, error) {
	out, err := runCommand("bw", payload, "encode")
	if err != nil {
		return "", fmt.Errorf("encode Bitwarden payload: %w", err)
	}
	return strings.TrimSpace(string(out)), nil
}

func runCommand(name string, stdin []byte, args ...string) ([]byte, error) {
	cmd := exec.Command(name, args...)
	if stdin != nil {
		cmd.Stdin = bytes.NewReader(stdin)
	}
	var stdout bytes.Buffer
	var stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		if stderr.Len() > 0 {
			return nil, fmt.Errorf("%w: %s", err, strings.TrimSpace(stderr.String()))
		}
		return nil, err
	}
	return stdout.Bytes(), nil
}

func showDiffSummary(target ManagedTarget, canonical, local string) {
	if target.Tool == "ssh" && target.Artifact == "key" {
		fmt.Fprintf(os.Stdout, "Canonical checksum: %s\n", checksum(canonical))
		fmt.Fprintf(os.Stdout, "Local checksum:     %s\n", checksum(local))
		return
	}
	if diffOutput, err := unifiedDiff(canonical, local); err == nil && strings.TrimSpace(diffOutput) != "" {
		fmt.Fprintln(os.Stdout, diffOutput)
		return
	}
	fmt.Fprintf(os.Stdout, "Canonical checksum: %s\n", checksum(canonical))
	fmt.Fprintf(os.Stdout, "Local checksum:     %s\n", checksum(local))
}

func unifiedDiff(canonical, local string) (string, error) {
	tmpDir, err := os.MkdirTemp("", "devtainer-diff-")
	if err != nil {
		return "", err
	}
	defer os.RemoveAll(tmpDir)
	left := filepath.Join(tmpDir, "canonical")
	right := filepath.Join(tmpDir, "local")
	if err := os.WriteFile(left, []byte(canonical), 0o600); err != nil {
		return "", err
	}
	if err := os.WriteFile(right, []byte(local), 0o600); err != nil {
		return "", err
	}
	cmd := exec.Command("diff", "-u", "--label", "canonical", "--label", "local", left, right)
	var stdout bytes.Buffer
	var stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	err = cmd.Run()
	if err == nil {
		return "", nil
	}
	var exitErr *exec.ExitError
	if errors.As(err, &exitErr) && exitErr.ExitCode() == 1 {
		return stdout.String(), nil
	}
	if stderr.Len() > 0 {
		return "", errors.New(strings.TrimSpace(stderr.String()))
	}
	return "", err
}

func confirmAction(skip bool, prompt string) (bool, error) {
	if skip {
		return true, nil
	}
	stat, err := os.Stdin.Stat()
	if err != nil {
		return false, err
	}
	if stat.Mode()&os.ModeCharDevice == 0 {
		return false, errors.New("confirmation required in non-interactive mode; pass --yes to continue")
	}
	fmt.Fprintf(os.Stderr, "%s [y/N]: ", prompt)
	reader := bufio.NewReader(os.Stdin)
	line, err := reader.ReadString('\n')
	if err != nil && !errors.Is(err, io.EOF) {
		return false, err
	}
	answer := strings.ToLower(strings.TrimSpace(line))
	return answer == "y" || answer == "yes", nil
}

func expandPath(path string) (string, error) {
	if path == "" {
		return "", errors.New("empty path")
	}
	if path == "~" || strings.HasPrefix(path, "~/") {
		home, err := os.UserHomeDir()
		if err != nil {
			return "", err
		}
		if path == "~" {
			return home, nil
		}
		return filepath.Join(home, strings.TrimPrefix(path, "~/")), nil
	}
	return path, nil
}

func checksum(content string) string {
	hash := sha256.Sum256([]byte(content))
	return hex.EncodeToString(hash[:8])
}

func stringValue(value any) string {
	switch v := value.(type) {
	case string:
		return v
	default:
		return ""
	}
}

func loadProfileForState(name string) Profile {
	cfg, _, err := loadConfig()
	if err != nil {
		return Profile{}
	}
	return cfg.Profiles[name]
}

func normalizeError(err error) string {
	return strings.TrimSpace(err.Error())
}

func renderDoctorReport(w io.Writer, report doctorReport, verbose bool) {
	fmt.Fprintf(w, "%s %s %s\n", statusLabel(statusLabelStyle(report.BitwardenStatus == "unlocked", report.BitwardenStatus == "locked"), "bw"), colorize(colorAyuGray, "Bitwarden status:"), report.BitwardenStatus)
	for _, target := range report.Targets {
		fmt.Fprintf(w, "\n%s\n", colorize(colorAyuCyan, target.DisplayName))
		fmt.Fprintf(w, "  profile: %s\n", target.Profile)
		fmt.Fprintf(w, "  path: %s\n", target.Path)
		if target.SelectedItem == "" {
			fmt.Fprintf(w, "  selected item: %s\n", colorize(colorAyuYellow, "not configured"))
		} else {
			fmt.Fprintf(w, "  selected item: %s\n", target.SelectedItem)
		}
		switch target.LocalFileStatus {
		case "missing":
			fmt.Fprintf(w, "  local file: %s (%s)\n", colorize(colorAyuRed, "missing"), target.Error)
		default:
			if target.Error != "" && target.IssueKind == "stat_error" {
				fmt.Fprintf(w, "  stat: %s\n", target.Error)
			}
		}
		fmt.Fprintf(w, "  permissions: %s\n", renderPermissionStatus(target.Permissions))
		if target.LastApplied != "" {
			fmt.Fprintf(w, "  last applied: %s\n", target.LastApplied)
		}
		switch target.BitwardenCompare {
		case "in_sync":
			fmt.Fprintf(w, "  bitwarden compare: %s\n", colorize(colorAyuGreen, "in sync"))
		case "differs":
			fmt.Fprintf(w, "  bitwarden compare: %s\n", colorize(colorAyuYellow, "differs"))
		case "failed":
			fmt.Fprintf(w, "  bitwarden compare: %s (%s)\n", colorize(colorAyuRed, "failed"), target.Error)
		case "unavailable":
			fmt.Fprintf(w, "  bitwarden compare: %s\n", colorize(colorAyuYellow, "unavailable"))
		default:
			if verbose && target.Error != "" && target.LocalFileStatus != "missing" && target.IssueKind != "permission_mismatch" && target.IssueKind != "ok" {
				fmt.Fprintf(w, "  detail: %s\n", target.Error)
			}
		}
	}
	if len(report.Hints) > 0 {
		fmt.Fprintln(w)
		for _, hint := range report.Hints {
			fmt.Fprintf(w, "%s %s\n", statusLabel("hint", "hint"), hint)
		}
	}
}

func renderPermissionStatus(status string) string {
	switch {
	case status == "ok":
		return colorize(colorAyuGreen, status)
	case strings.HasPrefix(status, "fixed"):
		return colorize(colorAyuGreen, status)
	case strings.HasPrefix(status, "expected"):
		return colorize(colorAyuYellow, status)
	case strings.HasPrefix(status, "failed"):
		return colorize(colorAyuRed, status)
	default:
		return status
	}
}

func defaultProfile(name string) Profile {
	return Profile{
		SSHConfig:      fmt.Sprintf("devtainer/ssh/config/%s", name),
		SSHKey:         fmt.Sprintf("devtainer/ssh/id_ed25519/%s", name),
		GitCredentials: fmt.Sprintf("devtainer/git/credentials/%s", name),
		KubeConfig:     fmt.Sprintf("devtainer/kube/config/%s", name),
		ArgoCDConfig:   fmt.Sprintf("devtainer/argocd/config/%s", name),
	}
}

func applyProfileDefaults(cfg *Config) {
	for name, profile := range cfg.Profiles {
		defaults := defaultProfile(name)
		if profile.SSHConfig == "" {
			profile.SSHConfig = profile.SSHConfigItem
		}
		if profile.SSHKey == "" {
			profile.SSHKey = profile.SSHKeyItem
		}
		if profile.GitCredentials == "" {
			profile.GitCredentials = profile.GitCredentialsItem
		}
		if profile.KubeConfig == "" {
			profile.KubeConfig = profile.KubeConfigItem
		}
		if profile.ArgoCDConfig == "" {
			profile.ArgoCDConfig = profile.ArgoCDConfigItem
		}
		if profile.SSHConfig == "" {
			profile.SSHConfig = defaults.SSHConfig
		}
		if profile.SSHKey == "" {
			profile.SSHKey = defaults.SSHKey
		}
		if profile.GitCredentials == "" {
			profile.GitCredentials = defaults.GitCredentials
		}
		if profile.KubeConfig == "" {
			profile.KubeConfig = defaults.KubeConfig
		}
		if profile.ArgoCDConfig == "" {
			profile.ArgoCDConfig = defaults.ArgoCDConfig
		}
		profile.SSHConfigItem = profile.SSHConfig
		profile.SSHKeyItem = profile.SSHKey
		profile.GitCredentialsItem = profile.GitCredentials
		profile.KubeConfigItem = profile.KubeConfig
		profile.ArgoCDConfigItem = profile.ArgoCDConfig
		cfg.Profiles[name] = profile
	}
}

func configToView(cfg *Config) configView {
	view := configView{
		ActiveProfile: cfg.ActiveProfile,
		Profiles:      map[string]profileItemsView{},
	}
	for name, profile := range cfg.Profiles {
		view.Profiles[name] = profileItemsView{
			SSHConfigItem:      profile.SSHConfig,
			SSHKeyItem:         profile.SSHKey,
			GitCredentialsItem: profile.GitCredentials,
			KubeConfigItem:     profile.KubeConfig,
			ArgoCDConfigItem:   profile.ArgoCDConfig,
		}
	}
	return view
}

func startSpinner(message string) *spinner {
	if !useInteractiveStderr() {
		return nil
	}
	s := &spinner{
		message: message,
		done:    make(chan struct{}),
	}
	s.wg.Add(1)
	go func() {
		defer s.wg.Done()
		frames := []string{"⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"}
		idx := 0
		ticker := time.NewTicker(90 * time.Millisecond)
		defer ticker.Stop()
		for {
			frame := colorizeForStderr(colorAyuBlue, frames[int(math.Mod(float64(idx), float64(len(frames))))])
			fmt.Fprintf(os.Stderr, "\r%s %s", frame, s.message)
			idx++
			select {
			case <-s.done:
				fmt.Fprintf(os.Stderr, "\r\033[K")
				return
			case <-ticker.C:
			}
		}
	}()
	return s
}

func (s *spinner) Stop(err error) {
	if s == nil {
		return
	}
	close(s.done)
	s.wg.Wait()
	status := statusLabel("ok", "done")
	if err != nil {
		status = statusLabel("fail", "fail")
	}
	fmt.Fprintf(os.Stderr, "%s %s\n", status, s.message)
}

func bootstrapUpdateHint(target ManagedTarget) string {
	if target.Tool == "ssh" && target.Artifact == "key" {
		return "devtainer update ssh --artifact key"
	}
	return "devtainer update " + target.Tool
}

func statusLabel(kind, text string) string {
	switch kind {
	case "ok":
		return colorize(colorAyuGreen, "["+text+"]")
	case "warn":
		return colorize(colorAyuYellow, "["+text+"]")
	case "fail":
		return colorize(colorAyuRed, "["+text+"]")
	case "hint":
		return colorize(colorAyuBlue, "["+text+"]")
	default:
		return "[" + text + "]"
	}
}

func statusLabelStyle(ok, warn bool) string {
	if ok {
		return "ok"
	}
	if warn {
		return "warn"
	}
	return "fail"
}

func colorize(color, text string) string {
	if !useColor() {
		return text
	}
	return color + text + colorReset
}

func colorizeForStderr(color, text string) string {
	if !useInteractiveStderr() || os.Getenv("NO_COLOR") != "" {
		return text
	}
	return color + text + colorReset
}

func useColor() bool {
	if os.Getenv("NO_COLOR") != "" {
		return false
	}
	info, err := os.Stdout.Stat()
	if err != nil {
		return false
	}
	return info.Mode()&os.ModeCharDevice != 0
}

func useInteractiveStderr() bool {
	info, err := os.Stderr.Stat()
	if err != nil {
		return false
	}
	return info.Mode()&os.ModeCharDevice != 0
}

func printRootHelp(w io.Writer) {
	fmt.Fprintln(w, "devtainer manages local tool config from Bitwarden-backed profiles.")
	fmt.Fprintln(w)
	fmt.Fprintln(w, "Usage:")
	fmt.Fprintln(w, "  devtainer config init --profile personal")
	fmt.Fprintln(w, "  devtainer profile list")
	fmt.Fprintln(w, "  devtainer profile use work")
	fmt.Fprintln(w, "  devtainer profile set-item work kube-config devtainer/kube/config/work")
	fmt.Fprintln(w, "  devtainer profile set-item work argocd-config devtainer/argocd/config/work")
	fmt.Fprintln(w, "  devtainer bootstrap bitwarden argocd")
	fmt.Fprintln(w, "  devtainer bootstrap bitwarden")
	fmt.Fprintln(w, "  devtainer setup ssh")
	fmt.Fprintln(w, "  devtainer setup all")
	fmt.Fprintln(w, "  devtainer doctor kube")
	fmt.Fprintln(w, "  devtainer doctor --json")
	fmt.Fprintln(w, "  devtainer checkhealth")
	fmt.Fprintln(w, "  devtainer update ssh --artifact key")
	fmt.Fprintln(w)
	fmt.Fprintln(w, "Commands:")
	fmt.Fprintln(w, "  config   Manage CLI config")
	fmt.Fprintln(w, "  profile  Manage named profiles")
	fmt.Fprintln(w, "  bootstrap Seed Bitwarden items from local files")
	fmt.Fprintln(w, "  setup    Materialize local files from Bitwarden")
	fmt.Fprintln(w, "  doctor   Compare local files with the selected Bitwarden items")
	fmt.Fprintln(w, "  checkhealth Alias for doctor")
	fmt.Fprintln(w, "  update   Promote local file changes back into Bitwarden")
	fmt.Fprintln(w, "  version  Print the CLI version")
}

func printConfigHelp(w io.Writer) {
	fmt.Fprintln(w, "Usage:")
	fmt.Fprintln(w, "  devtainer config path")
	fmt.Fprintln(w, "  devtainer config init --profile personal")
	fmt.Fprintln(w, "  devtainer config show")
}

func printProfileHelp(w io.Writer) {
	fmt.Fprintln(w, "Usage:")
	fmt.Fprintln(w, "  devtainer profile list")
	fmt.Fprintln(w, "  devtainer profile show")
	fmt.Fprintln(w, "  devtainer profile add <name> [--clone existing]")
	fmt.Fprintln(w, "  devtainer profile set-item <profile> <slot> <bitwarden-item>")
	fmt.Fprintln(w, "  devtainer profile use <name>")
}
