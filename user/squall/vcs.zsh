# see https://github.com/dirk-thomas/vcstool/blob/master/vcstool-completion/vcs.zsh
function _vcs()
{
    local opts
    reply=()

    if [[ ${CURRENT} == 2 ]]; then
        opts=`vcs --commands`
        reply=(${=opts})
    fi
}

compctl -K "_vcs" "vcs"
