#!/bin/bash
export ODOO_URL=$(awk '/ODOO/ {sub(/^.* *ODOO/,""); print $2}' releases.txt)
export PGADMIN_URL=$(awk '/PGADMIN/ {sub(/^.* *PGADMIN/,""); print $2}' releases.txt)
python app.py
echo "ODOO_URL : $ODOO_URL"
echo "PGADMIN_URL : $PGADMIN_URL"