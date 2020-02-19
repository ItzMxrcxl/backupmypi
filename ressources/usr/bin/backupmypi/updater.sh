SCRIPT="backupmypi"
SCRIPTPATH="/usr/bin/backupmypi/temp"
SCRIPTNAME="install.sh"
ARGS="$@"
BRANCH="master"

self_update() {
    cd $SCRIPTPATH
    git fetch

    [ -n $(git diff --name-only origin/$BRANCH | grep $SCRIPTNAME) ] && {
        echo "Found updates for the Script..."
		mkdir $SCRIPTPATH
        git pull --force
        git checkout $BRANCH
        git pull --force
        echo "Start install new Version..."
        exec "$SCRIPTNAME" "$@"
        exit 100
    }
    echo "Script up to date."
}