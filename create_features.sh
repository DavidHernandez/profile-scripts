#!/bin/bash
array=( taxonomy menu_custom filter field_base field_instance node commerce_customer commerce_product_type flag profile2_type views_view user_role rules_config elysia_cron feeds_importer user_permission)
PAQUETE=`ls | sed -rn 's/([a-zA-Z0-9\_]+)\.info/\1/p'`
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
