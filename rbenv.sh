#!/bin/bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
rbenv install 2.1.1
rbenv global 2.1.1
rbenv rehash

ruby -v
gem -v

