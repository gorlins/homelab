.PHONY: all

all: omni/infra/patches/argocd.yaml omni/infra/patches/cilium.yaml

omni/infra/patches/argocd.yaml: omni/apps/argocd/argocd/*.yaml
	kustomize build omni/apps/argocd/argocd | yq -i 'with(.cluster.inlineManifests.[] | select(.name=="argocd"); .contents=load_str("/dev/stdin"))' $@

omni/infra/patches/cilium.yaml: omni/apps/kube-system/cilium/*.yaml
	helm template cilium omni/apps/kube-system/cilium --namespace kube-system | yq -i 'with(.cluster.inlineManifests.[] | select(.name=="cilium"); .contents=load_str("/dev/stdin"))' $@
