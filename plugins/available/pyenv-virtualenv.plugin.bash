# make sure virtualenvwrapper is enabled if available

cite about-plugin
about-plugin 'pyenv-virtualenvwrapper helper functions'

export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
autoenv_env > /dev/null 2>&1
export AUTOENV=$?

[[ `which pyenv` ]] && eval "$(pyenv init -)"
[[ `which pyenv-virtualenvwrapper` ]] && pyenv virtualenvwrapper

# Activate autoenv
source /usr/local/opt/autoenv/activate.sh

function mkpvenv {
  about 'create a new virtualenv for this directory'
  group 'pyenv-virtualenv'

  cwd=`basename \`pwd\``

  if [[ $AUTOENV == 0 ]]; then
    _mkautoenv
  fi

  mkvirtualenv --distribute $cwd
}

function _mkautoenv {
  eval "touch .env"
  eval "echo \"#!/bin/bash\" >> .env"
  eval "echo \"if [ \\\`basename \\\$(pwd)\\\` == \\\"$cwd\\\" ]; then \"eval \"wopvenv\"\"; fi\" >> .env"
}

function _rmautoenv {
  eval "rm .env"
}

function mkpvbranch {
  about 'create a new virtualenv for the current branch'
  group 'pyenv-virtualenv'

  mkvirtualenv --distribute "$(basename `pwd`)@$SCM_BRANCH"
}

function wopvbranch {
  about 'sets workon branch'
  group 'pyenv-virtualenv'

  workon "$(basename `pwd`)@$SCM_BRANCH"
}

function wopvenv {
  about 'works on the virtualenv for this directory'
  group 'virtualenv'

  workon "$(basename `pwd`)"
}

function rmpvenv {
  about 'removes virtualenv for this directory'
  group 'virtualenv'

  eval "deactivate"
  rmvirtualenv "$(basename `pwd`)"

  if [[ $AUTOENV == 0 ]]; then
    _rmautoenv
  fi
}

function rmpvenvbranch {
  about 'removes virtualenv for this directory'
  group 'virtualenv'

  eval "deactivate"
  rmvirtualenv "$(basename `pwd`)@$SCM_BRANCH"
}