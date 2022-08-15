namespace = kube-logging

ns:
	@cat logging-ns.yaml | sed "s|NAMESPCE|$(namespace)|g" | kubectl apply -f -

sc: ns
	@kubectl apply -f sc.yaml

log-demo: sc
	@kubectl apply -f log-container.yaml

kibana-svc: log-demo
	@cat kibana-service.yaml | sed "s|NAMESPCE|$(namespace)|g" | kubectl apply -f -

kibana-deploy: kibana-svc
	@cat kibana-deploy.yaml | sed "s|NAMESPCE|$(namespace)|g" | kubectl apply -f -

kibana-ingress: kibana-deploy
	@cat kibana-ingress.yaml | sed "s|NAMESPCE|$(namespace)|g" | kubectl apply -f -

fluentd-cm: kibana-ingress
	@cat fluentd-es-configmap.yaml | sed "s|NAMESPCE|$(namespace)|g" | kubectl apply -f -

fluentd-ds: fluentd-cm	
	@cat fluentd-es-ds.yaml | sed "s|NAMESPCE|$(namespace)|g" | kubectl apply -f -

elasticsearch-service: fluentd-ds
	@cat es-service.yaml | sed "s|NAMESPCE|$(namespace)|g" | kubectl apply -f -

all-stack: elasticsearch-service
	@cat es-sts.yaml | sed "s|NAMESPCE|$(namespace)|g" | kubectl apply -f -

# to destroy everything

destroy:
	@cat logging-ns.yaml | sed "s|NAMESPCE|$(namespace)|g" | kubectl delete -f - --force
	