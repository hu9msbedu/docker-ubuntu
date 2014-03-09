#!/bin/bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
rbenv install 2.1.1
rbenv global 2.1.1
rbenv rehash

ruby -v
gem -v

