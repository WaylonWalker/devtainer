package main

import (
	"os"
	"path/filepath"
	"testing"
)

func TestApplyProfileDefaultsUsesItemAliases(t *testing.T) {
	cfg := &Config{
		ActiveProfile: "personal",
		Profiles: map[string]Profile{
			"personal": {
				SSHConfigItem:      "bw/ssh-config",
				SSHKeyItem:         "bw/ssh-key",
				GitCredentialsItem: "bw/git-creds",
				KubeConfigItem:     "bw/kube-config",
				ArgoCDConfigItem:   "bw/argocd-config",
			},
		},
	}

	applyProfileDefaults(cfg)
	profile := cfg.Profiles["personal"]

	if profile.SSHConfig != "bw/ssh-config" {
		t.Fatalf("expected ssh config alias to hydrate canonical field, got %q", profile.SSHConfig)
	}
	if profile.ArgoCDConfig != "bw/argocd-config" {
		t.Fatalf("expected argocd config alias to hydrate canonical field, got %q", profile.ArgoCDConfig)
	}
	if profile.GitCredentialsItem != "bw/git-creds" {
		t.Fatalf("expected canonical field to backfill item alias, got %q", profile.GitCredentialsItem)
	}
}

func TestConfigToViewUsesItemNames(t *testing.T) {
	cfg := &Config{
		ActiveProfile: "personal",
		Profiles: map[string]Profile{
			"personal": defaultProfile("personal"),
		},
	}

	view := configToView(cfg)
	profile := view.Profiles["personal"]

	if profile.SSHConfigItem == "" || profile.ArgoCDConfigItem == "" {
		t.Fatal("expected config view to expose item fields")
	}
	if profile.SSHConfigItem != "devtainer/ssh/config/personal" {
		t.Fatalf("unexpected ssh item ref %q", profile.SSHConfigItem)
	}
}

func TestDoctorTargetPermissionMismatch(t *testing.T) {
	tmp := t.TempDir()
	path := filepath.Join(tmp, "config")
	if err := os.WriteFile(path, []byte("hello"), 0o644); err != nil {
		t.Fatal(err)
	}

	result := doctorTarget(nil, "personal", defaultProfile("personal"), ManagedTarget{
		Tool:        "kube",
		Artifact:    "config",
		DisplayName: "kube config",
		DefaultPath: path,
		Mode:        0o600,
		ItemName:    func(Profile) string { return "devtainer/kube/config/personal" },
	}, false, false, doctorPrefetch{resolutions: map[string]*bwResolution{}, errors: map[string]error{}})

	if result.IssueKind != "permission_mismatch" {
		t.Fatalf("expected permission_mismatch, got %q", result.IssueKind)
	}
	if !result.Fixable {
		t.Fatal("expected permission mismatch to be fixable")
	}
	if result.Permissions != "expected 0600 got 0644" {
		t.Fatalf("unexpected permissions message %q", result.Permissions)
	}
}

func TestDoctorTargetMissingItem(t *testing.T) {
	tmp := t.TempDir()
	path := filepath.Join(tmp, "config")
	if err := os.WriteFile(path, []byte("hello"), 0o600); err != nil {
		t.Fatal(err)
	}
	ref := "devtainer/kube/config/personal"

	result := doctorTarget(nil, "personal", defaultProfile("personal"), ManagedTarget{
		Tool:        "kube",
		Artifact:    "config",
		DisplayName: "kube config",
		DefaultPath: path,
		Mode:        0o600,
		ItemName:    func(Profile) string { return ref },
	}, true, false, doctorPrefetch{resolutions: map[string]*bwResolution{}, errors: map[string]error{ref: os.ErrNotExist}})

	if result.IssueKind != "compare_failed" {
		t.Fatalf("expected compare_failed for generic error, got %q", result.IssueKind)
	}

	result = doctorTarget(nil, "personal", defaultProfile("personal"), ManagedTarget{
		Tool:        "kube",
		Artifact:    "config",
		DisplayName: "kube config",
		DefaultPath: path,
		Mode:        0o600,
		ItemName:    func(Profile) string { return ref },
	}, true, false, doctorPrefetch{resolutions: map[string]*bwResolution{}, errors: map[string]error{ref: errNoNamedItem(ref)}})

	if result.IssueKind != "missing_item" {
		t.Fatalf("expected missing_item, got %q", result.IssueKind)
	}
}

func errNoNamedItem(ref string) error {
	return &namedItemError{ref: ref}
}

type namedItemError struct{ ref string }

func (e *namedItemError) Error() string { return "no Bitwarden item named \"" + e.ref + "\"" }
