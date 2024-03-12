package terraform.module

import data.terraform.module as terraform

test_skip_resource_by_tag {
	resource = {"foo": "bar", "tags": [{"opa_skip": "opa1,opa2,op3", "opa_skip_1": "test2"}]}

	terraform.skip_resource_evaluation(resource, "opa1", [])
}

test_skip_resource_by_global_list {
	resource = {"foo": "bar", "tags": [{"opa_skip": "test", "opa_skip_1": "test2"}]}

	terraform.skip_resource_evaluation(resource, "opa1", ["opa1", "opa2"])
}

test_dont_skip_resource_by_tag {
	resource = {"foo": "bar", "tags": [{"opa_skip": "opa1,opa2,op3", "opa_skip_1": "test2"}]}

	not terraform.skip_resource_evaluation(resource, "opa4", [])

	true == true
}
