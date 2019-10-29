1. Create a record for the new project 
  * See [instruction file](http://bic.med.upenn.edu/bicTeam/BSC_Team_Core_Business/blob/master/Instructions.docx) 
  * Create the project record under [Gitlab project creation]( http://bic.med.upenn.edu/bicTeam/BSC_Team_Core_Business/tree/master/Project_Related/Project_Creation)
  * OR create the project  record on HPC under /project/ibilab/BIC_Team_Core_Business/Project_Related/Project_Creation , then push to Gitlab

2. Create the project on Gitlab
  * log in http://bic.med.upenn.edu/ and create a new project, e.g. "Rebecca_Simmons_RNAseq_Amita_2016_1" (Project_Name)
     - Project path : Rebecca_Simmons_RNAseq_Amita_2016_1
     - Namespace : bicTeam
     - Description : key terms of this project
     - Visibility Level : Private
  * Copy the SSH link of this project, e.g. git@BIC.MED.upenn.edu:bicTeam/Rebecca_Simmons_RNAseq_Amita_2016_1.git	 
  * (For future reference) Version Control : branch current progress of a project (on Gitlab web)
	 - On the left side bar, go to “Commits”
	 - On top of the page, go to “Branches”
	 - On upper-right corner, go for “New branch”
	 - Choose a name for the new branch and specify the origin of the branch

3. Create the project work directory on HPC	 
  * First setup [GitLab without authentication on HPC](http://bic.med.upenn.edu/bicTeam/BSC_Team_Core_Business/blob/master/Bioinfo_Resources/Gitlab/GitLabSetup.docx)	
  * Automatic work directory creation
	 - log in HPC, change to an interactive node (i.e. "bsub -Is bash"). 
	 - Get the SSH link of the project from Gitlab (this is the project SSH link you copied above), e.g. git@BIC.MED.upenn.edu:bicTeam/Rebecca_Simmons_RNAseq_Amita_2016_1.git (Project_SSH_Link)
	 - Run the following commands

	```	
	cd /project/ibilab/projects
	
	proj_create Project_SSH_Link Project_Name [Optional pipeline name, e.g. RNAseq, Chipseq ...]
	e.g.
	  proj_create git@BIC.MED.upenn.edu:bicTeam/Rebecca_Simmons_RNAseq_Amita_2016_1.git  Rebecca_Simmons_RNAseq_Amita_2016_1 [RNAseq|Chipseq ...]
	```
  * **OR** Manually create the work directory 
	 - log in HPC, change to an interactive node (i.e. "bsub -Is bash"). 
	 - Get SSH link of the project from Gitlab, e.g. git@BIC.MED.upenn.edu:bicTeam/Rebecca_Simmons_RNAseq_Amita_2016_1.git 
  
	```
	cd /project/ibilab/projects
	cp -r ../BIC_Team_Core_Business/Project_Related/Project_Template/ Rebecca_Simmons_RNAseq_Amita_2016_1
	cd Rebecca_Simmons_RNAseq_Amita_2016_1
	mv project_name_for_Gitlab Rebecca_Simmons_RNAseq_Amita_2016_1

	cd /project/ibilab/projects/Rebecca_Simmons_RNAseq_Amita_2016_1/Rebecca_Simmons_RNAseq_Amita_2016_1
	git init 
	git remote add origin  git@BIC.MED.upenn.edu:bicTeam/Rebecca_Simmons_RNAseq_Amita_2016_1.git
	git remote set-url origin  git@BIC.MED.upenn.edu:bicTeam/Rebecca_Simmons_RNAseq_Amita_2016_1.git
	git add .
	git commit -m 'initial commit'
	git status
	git push --set-upstream origin master
	```
4. [Email to client](http://bic.med.upenn.edu/bicTeam/BSC_Team_Core_Business/blob/master/Project_Related/Email_Client_After_Project_Creation.txt) with [Gitlab instructions](http://bic.med.upenn.edu/bicTeam/BSC_Team_Core_Business/blob/master/Bioinfo_Resources/Gitlab/GitLab_GuideForClients.pdf) after project creation on Gitlab

5. (For future reference) Update changes to Gitlab

	```
	cd /project/ibilab/projects/Rebecca_Simmons_RNAseq_Amita_2016_1/Rebecca_Simmons_RNAseq_Amita_2016_1
	git pull
	git add .
	git commit -m 'details of project change...'
	git push
	```

6. (For future reference) Clone an existing Gitlab project from web to server

	```
	git clone git@BIC.MED.upenn.edu:bicTeam/Rebecca_Simmons_RNAseq_Amita_2016_1.git
	```