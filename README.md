# Paul's Development Virtual Machine

This repo describes (with Vagrant) how to build my development virtual machine
(VM), with lots of dev dependencies installed and configured.

Feel free to fork and adapt this to your needs.

## Why use a Dev VM?

### Sandbox other people's code

Are any of these familiar?

- "hipsterlib is simple to install: `curl hipster.io/install | sudo bash`"
- "just do `sudo npm install -G hipster-lib"

I've got a blog post in me about this, but in short, running other people's
code is dangerous. Running it as *root* is extremely dangerous. I like to
limit both:

1. Who I trust to run code on my system (eg the Debian & Ubuntu developers)
2. Where that code is allowed to run (eg not in the same place as my GPG and
   SSH keys).

I use a development VM to limit the damage that can be done to my personal
machine - especially my private keys.

### Make a reproducible environment

Ever bought a new machine and spent hours or days trying to remember how
you installed the latest node/ruby/python/whatever?

Having the whole machine source-controlled is super convenient. You can treat
it as throwaway - in fact, I strongly encourage you to
`vagrant destroy && vagrant up` at least once per week :)

## Prerequisities

Tested with:

- Virtualbox 1.5.0
- Vagrant 1.8.1

## Add an alias to .bashrc

I find it convenient to type `dev` and arrive straight in my dev VM.

```
alias dev='cd ~/dev && vagrant ssh || vagrant up && vagrant ssh'
```
