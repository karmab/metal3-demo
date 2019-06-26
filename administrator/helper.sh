alias k8scontextlist="kubectl config view -o jsonpath='{.contexts[*].name}' | tr ' ' '\n'"
alias k8scontext="kubectl config current-context"
alias k8sns="kubectl config get-contexts `kubectl config current-context`"

function k8sswitchcontext {
    kubectl config use-context $1
}
function k8sswitchns {
    kubectl config set-context `kubectl config current-context` --namespace=$1
}
export OS_TOKEN=fake-token
export OS_URL=http://localhost:6385
