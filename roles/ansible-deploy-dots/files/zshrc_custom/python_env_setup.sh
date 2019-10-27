# activate virtualenvwrapper
if [ -x /usr/local/bin/virtualenvwrapper.sh ]
    then
        export VIRTUALENVWRAPPER_PYTHON=$(command -v python3)
        source /usr/local/bin/virtualenvwrapper.sh

        # pip should only run if there is a virtualenv currently activated
        export PIP_REQUIRE_VIRTUALENV=true

        # create commands to override pip restriction.
        # use `gpip` or `gpip3` to force installation of
        # a package in the global python environment
        gpip(){
           PIP_REQUIRE_VIRTUALENV="" pip "$@"
        }
        gpip3(){
           PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
        }
else
        echo "virtualenvwrapper.sh missing"
        echo "Install it via: pip install virtualenvwrapper"
fi
