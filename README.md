Useful documentation: 

        - https://rubygems.org/gems/fluent-plugin-s3 # fluentd plugin itself and dependecies for S3
        - https://docs.fluentd.org/ # for output plugins as S3
        - https://github.com/fluent/ # official fluent github repo with all configs for fluentd
        - https://www.digitalocean.com/community/tutorials/how-to-set-up-an-elasticsearch-fluentd-and-kibana-efk-logging-stack-on-kubernetes #step by step deploying tutorial
        - https://medium.com/avmconsulting-blog/how-to-deploy-an-efk-stack-to-kubernetes- #deploying step-by-step
        - https://kubernetes.io/docs/concepts/storage/storage-classes/
        - https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-troubleshooting-methods.html

**AUTOMATION**

In order to automate deployment of EFK Stack, we can run 

        make namespace="desirable.namespace" all-stack

In order to destroy all our creature

        make destroy

**STEP 1.**

Creating namespace on which we are going to deploy our EFK STACK.

        - kubectl create ns logging --dry-run -o yaml > cm.yaml
        - kubectl apply -f cm.yaml
        - kubectl get ns # to check our newly created namespace

**STEP 2.**

Creating Elasticsearch StatefulSet

        - Copying yaml of elasticsearch statefulset from digitalocean resource and make change on namespace resource
        - He have to create storage class to map it to our statefulset in our to create pv,pvc as well to specify our cloud provider. In order to that please check K8S documentation linked above.
        - kubectl apply -f "file_name"yaml # to apply our .yaml file

**STEP 3.**

Creating Kibana deployment and service to connect to our deployment 
        
        - Copying yaml of elasticsearch deployment and service from digitalocean resource and make change on namespace resource
        -kubectl apply -f "file_name".yaml # service port for kibana will be 5601
        -kubectl port-forward <kibana_pod_name> 5601:5601 # to access GUI of our kibana  deployment

Go inside of your current browser and access the output of last above command:

        - 127.0.0.1:5601

**STEP 4.**

Deploying FluentD daemonset # it should be daemonset, because it should be deploying on each node in order to collect logs.

        - DigitalOcean source is providing as well daemonset of our fluentd, as well with all necessary dependencies for that. All we have to do is to copy it carefully and inspect current file for any necessary changes.
        - kubectl apply -f <curent.file>.yaml


**STEP 5.**

To check if our fluentd is working properly. Let's create a simple pod which will generate current date logs. And we can access them by accessing them in the browser

        - kubectl port-forward <kibana_pod_name> 5601:5601 # to check access GUI of our kibana  deployment
        - 127.0.0.1:5601

We have to create pattern index and timestamp.
Then we can filter our logs only by our deployed pod name which generates logs

**EFK over ELK**

```Logstash vs. Fluentd: Which one to use for Kubernetes?```

Data logging can be divided into two areas: event and error logging. Both Fluentd and Logstash can handle both logging types and can be used for different use cases, and even co-exist in your environments for logging both VMs/legacy applications as well as Kubernetes-based microservices.

For Kubernetes environments, Fluentd seems the ideal candidate due to its built-in Docker logging driver and parser – which doesn’t require an extra agent to be present on the container to push logs to Fluentd. In comparison with Logstash, this makes the architecture less complex and also makes it less risky for logging mistakes.
