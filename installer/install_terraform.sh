

# install terraform
curl https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o terraform.zip
unzip terraform.zip
chmod +x terraform
if [ /home/waylon/devtainer != /usr/local/bin ]; then
    mv terraform /usr/local/bin
fi

