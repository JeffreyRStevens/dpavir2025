
Setting up a Shiny account

1. Reach out to Tim Steiner (tim.steiner@nebraska.edu) to get an account created on the server.
2. Connect to the server in an ssh shell: `ssh username@its-ianr-shiny.unl.edu`. Enter your TrueYou password at the password prompt and accept the DUO 2FA request.
3. Create a `ShinyApps/` directory in your home directory that will house subdirectories for individual Shiny projects.
4. To copy files from your local computer to the server, use scp in a different shell (i.e., not inside your ssh session). For example, to copy the whole directory `projectname/` to the server, use `scp -r local_directory/path/projectname username@its-ianr-shiny.unl.edu:ShinyApps/`.
5. To install R packages, open an R session in your ssh shell by typing `R`. Type `install.packages(packagename)` at the R prompt. When you receive the warning that `'lib = "/usr/lib64/R/library"' is not writable. Would you like to use a personal library instead? (yes/No/cancel)`, type `yes` and allow R to create a personal library. Then select a CRAN mirror (e.g., 66: USA [IA]).
6. Once the files are uploaded and all packages are installed, you should be able to access your Shiny app at `https://its-ianr-shiny.unl.edu/users/username/projectname/`.




ssh jstevens5@its-ianr-shiny.unl.edu


scp -r ~/projects/dpavir_2025/exercises/ jstevens5@its-ianr-shiny.unl.edu:ShinyApps/dpavir2025/

https://its-ianr-shiny.unl.edu/users/jstevens5/dpavir2025/