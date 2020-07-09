# Pre-requsite  - Install and configure GCloud & initialise [You don't need this step if you are running locally]

[Go back to main page](../README.md)
# Enable the gke module
Step 1
```
Append  `.disabled` to the file called local_module.tf. It should look like  'local_module.tf.disabled'
```
Step 2
```
Append  `.disabled` to the file called aks_module.tf. It should look like  'aks_module.tf.disabled'
```
Step 3
```
Remove `.disabled` from the file called gke_module.tf.disabled. It should look like 'gke_module.tf'
```

# Install appropriate GCP/GKE tools
First, install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/quickstarts) 
```
Install gcloud sdk  - <Google Cloud SDK 284.0.0>

```
Initialize it...

```shell
$ gcloud init
```
gcloud Configure 
```shell
$ gcloud auth login
```
Configure glcoud to work with your Terraform.
```shell
$ gcloud auth application-default login
```
Configure local docker to work with google container repo GCR.
```shell
gcloud auth configure-docker
```

# Pre-requsite  - Important to read  terraform.tfvars and variable.tf

```
* Replace `terraform.tfvars` values with your `project_id` , `region` and other variables. Your  `project_id` &  `region`  must match the project you've initialized gcloud with. 

* You may not need project_id, region and few otehr variabled if you are running locally

* Do NOT use upper case for the value you are going to replace.
```


[Go back to main page](../README.md)