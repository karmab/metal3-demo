alias kcontextlist="kubectl config view -o jsonpath='{.contexts[*].name}' | tr ' ' '\n'"
alias kcontext="kubectl config current-context"
alias kns="kubectl config get-contexts `kubectl config current-context`"

function kcontextswitch {
    kubectl config use-context $1
}
function kswitchns {
    kubectl config set-context `kubectl config current-context` --namespace=$1
}
export OS_TOKEN=fake-token
export OS_URL=http://localhost:6385
