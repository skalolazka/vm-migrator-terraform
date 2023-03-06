You know,

```
# set up terraform.tfvars
terraform init
terraform apply
```

To delete all instances:
```
# change zone to yours, edit project ID
export $PROJECT=NOT_PUBLIC
gcloud compute instances list --project $PROJECT | grep -v NAME | cut -d' ' -f1 | perl -ple 's/(.*)/gcloud compute instances delete $1 --project $PROJECT --zone europe-west4-a --quiet/' > to_delete.sh
sh to_delete.sh
```

My current terraform.tfvars, you can copy it:
```
project_id = "NOT_PUBLIC"
instances = 2
source_region = "europe-west4"
source_zone = "europe-west4-a"
```
