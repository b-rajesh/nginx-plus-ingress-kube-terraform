# Pre-requsite  - format the file name
[Go back to main page](../README.md)

# Enable the aks module
Step 1
```
Append  `.disabled` to the file called local_module.tf. It should look like  'local_module.tf.disabled'
```
Step 2
```
Append  `.disabled` to the file called gke_module.tf. It should look like  'gke_module.tf.disabled'
```
Step 3
```
Remove `.disabled` from the file called aks_module.tf.disabled. It should look like 'aks_module.tf'
```
# Install appropriate azue roold
First, azure tools 
```
brew install azure-cli

```
Initialize it...

```shell
$ az login
```

# Pre-requsite - Important to read  terraform.tfvars and variable.tf

```
* Replace `terraform.tfvars` values with your `project_id` , `region` and other variables. Your  `project_id` &  `region`  must match the project you've initialized gcloud with. 

* You may not need project_id, region and few otehr variabled if you are running locally

* Do NOT use upper case for the value you are going to replace.
```

[Go back to main page](../README.md)