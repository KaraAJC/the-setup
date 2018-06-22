# Installfest

# So, you got yourself a new laptop, eh? Good for you! lets have an installfest party!

## What we'll cover
1. xcode!
2. System Updates
1. Understanding the Unix Environment
3. Dotfiles
1. `subl`
1. Homebrew
1. sqlite3
1. postgres
1. RVM/rbenv
1. Ruby
1. gems

### XCode!
A big part of your development environment is knowing your Mac's command Line Tools is all run through **XCode**. To keep this updated, you can run:
```sh
xcode-select --install
```
or, go to your **App Store** updates and confirm that it is updated. your first encounter with this application, it may prompt you to enter your user credentials, and that will help you have the access you need to do the rest of your installs. 

if you run the above line and get the following message: 
```sh
xcode-select: error: command line tools are already installed, use "Software Update" to install updates
```
hooray! Your XCode is updated!

### System Updates

Typically a laptop will ship with whatever the updates were at the time the computer was made, this means there will surely be updates that have happened since then. Use the **App Store** to make all the software updates before moving forward.

### `subl`

This is a command that allows you to open a file or directory in your Sublime Text code editor from the command line. After installing Sublime Text 3 from the website and putting it in your applications folder, run the following command:

```sh
ln -s  "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
```

This creates a symbolic link for your command line and you can run `subl SOME_FILENAME` to open a file in Sublime

## Homebrew

First let's ensure we've installed homebrew correctly.

```sh
$ which brew
/usr/local/bin/brew
```

If you don't see this, run:

```sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Homebrew is going to do a lot of work for us, so always ensure that it's
up-to-date and that it's healthy.

```sh
brew update
```
and

```sh
$ brew doctor
# … LOTS OF STUFF THAT NEEDS TO BE FIXED …
```

`brew doctor` may tell you a lot of stuff… you'll want to read through each
item, and attempt to resolve the issue for Homebrew. Warnings are good to read but are not mandatory to
fix. We're ideally shooting for
a message like this:

```sh
$ brew doctor
Your system is ready to brew.
```

## Adjusting $PATH for Homebrew

Homebrew is going to be installing packages and tools for us, so we need to make
sure that when possible, our system is using homebrew's installed packages.

We'll start by inspecting our path

```sh
$ echo $PATH | tr : '\n'
/Users/jon/bin
/usr/local/bin
/usr/bin
/bin
/usr/sbin
/sbin
/usr/local/bin
```

Ensure that `/usr/local/bin` comes before `/usr/bin` and `/bin`.

If it doesn't, open `$HOME/.bash_profile` using Sublime Text and add the
following:

```
export PATH="/usr/local/bin:$PATH"
```
*What is a bash profile? Learn more about a bash_profile here*
Also check out the [rbenv documentation](https://github.com/sstephenson/rbenv).

## Installing `sqlite3` using Homebrew

```sh
$ brew install sqlite3
```

OS X provides `sqlite3` for you, so we'll need to force homebrew to link it so
that we can use the homebrew version by default:

```sh
$ brew link sqlite3 --force
```

## Installing `postgres` using Homebrew

```sh
$ brew install postgres
```

`postgres` is a piece of software that requires a server to interface with. It's
easiest to let OS X's `launchd` utility keep this server running, otherwise we'd
have to restart it every time it died or our machine rebooted.

```sh
$ ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
$ launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
````

```sh
$ which postgres
/usr/local/bin/postgres
````

```sh
$ which psql
/usr/local/bin/psql
```

Now Homebrew will keep our postgres server alive so that we can just develop
awesome apps and not worry about the database. Let's ensure that we have a
server running. To do that we'll use `ps`:

```sh
ps aux | grep postgres

### As long as anything shows up on the screen, you will be fine. You don't need to match up with my output below

jon              444   0.0  0.0  2439324    148   ??  Ss   13Feb14   0:02.33 postgres: stats collector process
jon              443   0.0  0.0  2443176    624   ??  Ss   13Feb14   0:02.44 postgres: autovacuum launcher process
jon              442   0.0  0.0  2443044     80   ??  Ss   13Feb14   0:03.72 postgres: wal writer process
jon              441   0.0  0.0  2443044    132   ??  Ss   13Feb14   1:29.90 postgres: writer process
jon              440   0.0  0.0  2443044    136   ??  Ss   13Feb14   0:00.14 postgres: checkpointer process
jon              403   0.0  0.0  2443044     68   ??  S    13Feb14   0:00.40 /usr/local/opt/postgresql/bin/postgres -D /usr/local/var/postgres -r /usr/local/var/postgres/server.log
jon             6469   0.0  0.0  2432768    600 s000  R+    5:42PM   0:00.00 grep postgres
```

The process with `pid` (process id) #403 is our server process. You can see here
what executable (the full path) is running, where the data file is (ie.
`/usr/local/var/postgres`), and where we can find the logs (ie.
`/usr/local/var/postgres/server.log`).

Finally, create a default database and test our postgres client, `psql`.

```sh
createdb $USER
psql $USER # this is a sql console for interacting with a postgres database
enter `\q` to quit
```

## Managing Ruby Installations

`rvm`, `rbenv`,  or `chruby`? There are a number of different popular tools for
installing/managing/using different versions of ruby on your machine. We are going to use `rbenv`
for our classes.

## Verifying your Ruby Manager

```sh
which rbenv
$HOME/.rbenv/bin/rbenv
OR
/usr/local/bin/rbenv
```
If any of the above show up, ignore this next section.

```sh
which rvm
$HOME/.rvm/bin/rvm
```
If any of the above show up, please remove `rvm` and install `rbenv`

## Install `rbenv` using Homebrew

Visit this [site](https://github.com/rbenv/rbenv#homebrew-on-mac-os-x) and follow the instructions

`rbenv` will store ruby versions and gems to `$HOME/.rbenv`. There's no need to change
this. `ruby-build` is the tool that will do the installing.

Now that `rbenv` is installed, we need to configure our environment to use it.
The instructions say that we need to add the following to our
`$HOME/.bash_profile`:

```sh
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
```

Usage:

```sh
$ rbenv install --list      # will list all of the Rubies ruby-build can install
$ rbenv install 2.4.0       # will install ruby 2.4.0. This will take a while.
$ rbenv versions            # will list the Rubies you already have installed, should have `* system` selected
$ rbenv global 2.4.0        # will set the global/shell/local ruby
$ rbenv versions            # should see 2.4.0 selected
```

## Ruby

Let's make sure you're **NOT** using the system ruby.

```sh
$ which ruby
/Users/jon/.rbenv/shims/ruby
```

If this says `/usr/bin/ruby`, then we need to get your ruby installed via a ruby
version manager. I suggest rbenv (see above).

If you're using rbenv, run this:

```sh
$ rbenv which ruby
/Users/jon/.rbenv/versions/2.4.0/bin/ruby
```

Same as above, it should not say `/usr/bin/ruby`. If it does, then install a
ruby (via rbenv), then set it as your default ruby (`rbenv global <ruby version
you installed>`).

## Gems

Most gems are fairly easy to install, but there are a few that we use at CodePlatoon
that can be problematic (usually the ones with native dependencies). Let's start
by verifying that the gem executable is installed via a ruby version manager.

```sh
$ which gem
/Users/jon/.rbenv/shims/gem
```

You'll notice that `gem` is in the same directory as `ruby` (from above). This
is good. If they aren't in the same place, that's usually a problem. If it's
`/usr/bin/gem` that's an issue.

If you're using rbenv, run:

```sh
$ rbenv which gem
/Users/jon/.rbenv/versions/2.2.4/bin/gem
```

Again, just like ruby, this shouldn't say `/usr/bin/gem`. It should also be in
the same location as when you ran `rbenv which ruby`.

Let's also update rubygems.

```sh
$ gem update --system
# This may take a while
```

Alright, ON TO THE HARD GEMS! First, bundler.

```sh
gem install bundler
rbenv rehash        // if you're using rbenv, which you should be
```

And the rest:

```sh
gem install sqlite3 pg nokogiri
# Here, you're installing 3 gems! This is going to take a while...
```

## Install `git` using Homebrew

```sh
$ brew install git
```

Ensure we're using `git` from homebrew:
```sh
$ which git
/usr/local/bin/git
```

Question: _OS X ships with `git` isn't that good enough?_
Answer: It might be, but it's likely out of date, and you won't benefit from new
tools and developments. `git` is a tool we'll use frequently, so installing it
and keeping it up to date is akin to a chef keeping their knives sharp. Up-to-date
tools are one of the marks of a craftsman; strive to be a craftsman.

there are a few steps you should configure so git works well. 
The first, is setting up a global .gitignore file. 

`touch  ~/.gitignore_global`

Use [Github's Gitignore Guide](https://help.github.com/articles/ignoring-files/#create-a-global-gitignore) to setup the file according to your computer environment.

```sh
$ git config --global core.excludesfile '~/.gitignore_global'` 
```

Next, You'll want to get your gitconfig setup to recognize your github credentials. 

```sh
#### COMMANDS GO HERE!!!!####
user.name
user.email
osx keychain config
```

Finally, set Sublime to be your global text editor for all things Git:

```sh
$ git config --global core.editor "subl -n -w"
``` 

Confirm gitconfig is setup, both for your username/email and gitignore by running `git config --global -l`
You should see that your username, email, gitignore, and editor are all listed.

## Install `bash` using Homebrew

```sh
$ brew install bash
```

To use this new version of bash, we'll need to add it to `/etc/shells`.
`/etc/shells` is owned by the `root` user (verify using `ls -la /etc/shells`),
so we'll need to use `sudo` to write to it.

```sh
$ subl /etc/shells
# Add `/usr/local/bin/bash` to the last line and save
```

Now we need to change our shell command:

```sh
$ chsh -s /usr/local/bin/bash
```

All set. We can launch a new teminal window and verify our setup.

```sh
$ bash --version
```
