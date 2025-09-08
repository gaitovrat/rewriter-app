variable "location" {
  type        = string
  description = "The Azure region where resources will be created."
}

variable "project_name" {
  type        = string
  description = "Prefix for all resources"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to resources"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create resources."
}

variable "openai_model_name" {
  type        = string
  description = "The name of the OpenAI model to deploy."
}

variable "openai_model_version" {
  type        = string
  description = "The version of the OpenAI model to deploy."
}

variable "openai_model_sku_name" {
  type        = string
  description = "The SKU name for the OpenAI deployment."
}