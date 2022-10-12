#!/bin/bash
export ODOO_URL=$(awk '/ODOO/ {sub(/^.* *ODOO/,""); print $2}' releases.txt)
export PGADMIN_URL=$(awk '/PGADMIN/ {sub(/^.* *PGADMIN/,""); print $2}' releases.txt)
python app.py