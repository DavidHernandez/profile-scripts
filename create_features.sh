#!/bin/bash
array=( taxonomy menu_custom filter field_base field_instance node views_view user_role user_permission rules_config profile2_type flag elysia_cron feeds_importer)
PAQUETE=$1
for i in ${array[@]}
do
	feature_name=${PAQUETE}_$i
	if [ -f "modules/feature/${feature_name}/${feature_name}.info" ]
	then
		echo "Feature ${feature_name} already exists, we will increment the version number"
		drush fe $feature_name "$i:" --destination=profiles/${PAQUETE}/modules/feature --version-increment -y
	else
		echo "We will create the feature ${feature_name}"
		drush fe $feature_name "$i:" --destination=profiles/${PAQUETE}/modules/feature --version-set="7.x-1.0" -y
		sed -i "s/package = Features/package = Features ${PAQUETE}/" modules/feature/${feature_name}/${feature_name}.info
		drush en $feature_name -y
	fi
done
drush cc all
