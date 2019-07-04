#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

append_props() {
        service_prop_file="$1"
        aggregated_props_file=$2
        while read -r prop; do 
                echo "  $prop" >> $aggregated_props_file
        done < "$service_prop_file"
}


generate_aggregated_props_file() {
	
	env=$1
	aggregated_props_file="$DIR/${env}-props.yaml"
        aggregated_props_file_tpl="$DIR/${env}-props.yaml.tpl"

	if [ "$env" != "dev" ] && [ "$env" != "stage" ] && [ "$env" != "prod" ]; then
		echo "Invalid environment $env. Give any of dev, stage, prod"
		exit 1	
	fi

	touch $aggregated_props_file

	echo > $aggregated_props_file
	echo "db:" >> $aggregated_props_file	
	append_props ${DIR}/db/hyscale/${env}-props.yaml $aggregated_props_file
        echo "web:" >> $aggregated_props_file
	append_props ${DIR}/web/hyscale/${env}-props.yaml $aggregated_props_file
	echo "app:" >> $aggregated_props_file
 	append_props ${DIR}/app/hyscale/${env}-props.yaml $aggregated_props_file
}

generate_aggregated_props_file "dev"
generate_aggregated_props_file "stage"
generate_aggregated_props_file "prod"
