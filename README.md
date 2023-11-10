# sample ansible-playbooks

## IMS
- compilation of a COBOL program & free region

`ansible-playbook -i inventories IMS/pgm_compilation_COBOL_DB2.yml`

`ansible-playbook -i inventories IMS/pgm_compilation_COBOL_IMS_DB.yml`
- stop / start of MPRs

`ansible-playbook -i inventories IMS/stop_start_MPRs.yml`
- extended ACB gen & Catalog population

`ansible-playbook -i inventories IMS/extended_ACB_and_Catalog.yml`

## CICS
- compilation of a COBOL program & Newcopy in CICS

`ansible-playbook -i inventories -e @secrets.enc --vault-password-file password_file CICS/compil_pgm_PBOOKCMN.yml`
- compilation of a COBOL program with SQL statements & Newcopy in CICS

`ansible-playbook -i inventories -e @secrets.enc --vault-password-file password_file CICS/compil_pgm_PBOOKDB2.yml`
- add CICS resources

`ansible-playbook -i inventories -e @secrets.enc --vault-password-file password_file CICS/add_resources_zCEE_API-Requester.yml`

## Db2
- bind or grant on Db2 sub system

`ansible-playbook -i inventories Db2/bind_Db2.yml`

`ansible-playbook -i inventories Db2/grant_Db2.yml`

## z/OS Connect
- add API Provider

`ansible-playbook -i inventories zOS\ Connect/deploy_war_API-Provider.yml`

- add API Requester

`ansible-playbook -i inventories zOS\ Connect/deploy_war_API-Requester.yml`

## z/OS
- list user

`ansible-playbook -i inventories zOS/list_user.yml`

`ansible-playbook -i inventories zOS/command_on_list_users.yml`
- operator command

`ansible-playbook -i inventories zOS/opercmd.yml`
