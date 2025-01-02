  kubectl create secret generic vault-token --from-literal=token=hvs.dpdlNoMWMOl4YHgDgIkK5FsJ
  argocd login $(kubectl get svc -n argocd argocd-server | awk '{print $4}' | tail -1) --username admin --password$(argocd admin initial-password -n argocd | head -1) --insecure --grpc-web

  for app in  frontend catalogue user cart dispatch payment shipping; do
     argocd app create ${app}  --repo https://github.com/saiyadaz/roboshop-helm --path chart --dest-namespace default --dest-server https://kubernetes.default.svc --grpc-web --values values/${app}.yaml
     argocd app sync ${app}
  done
