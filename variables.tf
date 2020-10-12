variable "prefix" {
    description = "Unique prefix used for all resources."
}

variable "location" {
    description = "Region in which all resources will be created."
    default = "centralus"
}

variable "vm_count" {
    description = "Number of virtual machines."
    default = 1
}

variable "TENANT_ID" {
    description = "Tenant id."
}

variable "SUBSCR_ID" {
    description = "Subscription id."
}

variable "CLIENT_ID" {
    description = "Service principal id."
}

variable "CLIENT_SECRET" {
    description = "Service principal password."
}