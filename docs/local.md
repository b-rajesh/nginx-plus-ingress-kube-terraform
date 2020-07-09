# Pre-requsite 4 - To run locally

[Go back to main page](../README.md)

```
Install docker-desktop(latest)  locally and enable kubernetes cluster from the preferences. start the
```

# Enable the local module
Step 1
```
Append  `.disabled` to the file called aks_module.tf. It should look like  'aks_module.tf.disabled'
```
Step 2
```
Append  `.disabled` to the file called gke_module.tf. It should look like  'gke_module.tf.disabled'
```
Step 3
```
Remove `.disabled` from the file called local_module.tf.disabled. It should look like 'local_module.tf'
```

# Pre-requsite  - Important to read  terraform.tfvars and variable.tf

```
* Replace `terraform.tfvars` values with your `project_id` , `region` and other variables. Your  `project_id` &  `region`  must match the project you've initialized gcloud with. 

* You may not need project_id, region and few otehr variabled if you are running locally

* Do NOT use upper case for the value you are going to replace.
```


[Go back to main page](../README.md)