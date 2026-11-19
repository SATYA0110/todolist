terraform {
    backend "gcs" {
        bucket = "satya01109101"
        prefix = "terraform/state/prod"
    }

}