#!/bin/bash

URL: https://docs.gitlab.com/16.9/ee/user/ssh.html

1. ssh-keygen -t ed25519 -C "comment" > generate ssh key

1. copy public key by using below commands:
    mac="tr -d '' < ~/.ssh/id_ed25519.pub | pbcopy"
    windows="cat ~/.ssh/id_ed25519.pub | clip"


ssh -T git@gitlab-shell.decodedevops.com > Welcome to GitLab, @jithendar!
ssh -Tvvv git@gitlab-shell.decodedevops.com > get the complete debug information