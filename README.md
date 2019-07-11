# utility-scripts
Helpful shell scripts for terminal

## Installation / Setup
Details of a specific installation/step are system specific. Some things to consider include:
- Some scripts assume that an environmental variable `$projectFolder` exists, this variable holds a path to a directory that is a default location for your project folders. The following code can be added to .bash_profile to export an appropriate path into `$projectFolder`
    ```
    # Environmental Variables   
    projectFolder=<PATH_TO_PROJECT_FOLDER>; export projectFolder
    ```
- The scripts up.sh and cdp.sh need to be sourced, rather than ran, this is achieved by calling them with a preceding `.` or by creating suitable alias such as
    ```
    alias up.sh=". up"
    alias cdp.sh=". cdp"
    ```
- As is typical, the scripts need to be added to your PATH in order to be available from all locations. This can be achieved, for example, by adding the following to your .bash_profile
    ```
    # Add utility_scripts to PATH
    export PATH="<PATH_TO_UTILITY-SCRIPTS>:$PATH"
    ```
- The repo includes symbolic links to each of the *.sh script files. These are to enable the *.sh files to be called as commands without their `.sh` extension. Alternately, aliases could be created. This is merely a convenience, and the scripts can be run directly using their complete filename with extension if preferred.

## Scripts
More detailed comments are provided within each script, a summary of script usage is provied below:

### gsum.sh
gsum.sh generates a list of cryptographic hash values for all files within a directory.
A time stamp is prepended to the output file based on the current system time.
> Usage: `gsum.sh [-s source_directory] [-d destination_directory] [-a algorithm] [-f filename_label]`
> - Default behavior is to create hash values using SHA256 for all files within the current directory, saving the output to a timestamped *_checksums.txt file within the same directory
> - `-s source_directory` specifies a path to the directory for which checksums will be created. Default is the current directory from which the script is called.
> - `-d destination_directory` specifies a path to the directory in which the output .txt file will be saved. Default is the current directory from which the script is called.
> - `-a algorithm` specifies the openssl algorithm to use. Default is sha256
> - `-f file_label` specifies the filename label that is appended to the timestamp. Default is _checksums.txt

### smb2win.sh
smb2win.sh converts a smb path into a windows path.
> USAGE: `smb2win [-c] smb_path`
> - Default behavior prints the windows version of `smb_path` and copies this to clipboard  
e.g.: `smb2win.sh "smb://path/directory/file.txt"` prints "\\path\directory\file.txt" and copies this path to clipboard
> -	`-c` suppresses output to clipboard

### mkpdir.sh
mkpdir.sh creates a new project folder with standard subfolders and places these in $projectFolder.
> USAGE: `mkpdir.sh project_folder_name`
> - e.g.: `mkpdir.sh "1234567.000 - project name"` creates new directory `1234567.000 - project name` in `$projectFolder` and places standard subfolders within this new directory
> - NOTE: $projectFolder must be defined as an environmental variable, or line 10 of mkpdir.sh should be edited to your choice of path.

### cdp.sh
cdp.sh helps to easily navigate to a default project folder directory, and to projects within this directory.
> USAGE: `. cdp.sh [search_string [search_directory]]`
> - Call with no arguments to navigate to `$projectFolder`, if this variable does not exist consider exporting it from your .bash_profile as described in the Installation / Setup section above.
> - `search_string` is a substring that will be searched for within `search_directory`. The default for `search_directory` is `$projectFolder`.  
If `search_string` is found within a folder name in the `search_directory` then cpd.sh navigates to the matched folder.
> - `search_string` must match to only one subfolder within `search_directory`.

### lk.sh
lk.sh helps navigate to remote network locations, and interact with files at these locations.
> USAGE: `lk.sh [-l path | -o path | -c source_path destination_path | -d]`
- `-l path` opens `path` in finder  
e.g.: `lk.sh -l "//<networkPath>/<directory>"` opens `<directory>` at `<networkPath>`.  
- `-o path` opens a file specified by  `path`  
e.g.: `lk.sh -o "//<server>/<sharedFolder>/<exampleFile>"` opens `<exampleFile>` from `<sharedFolder>`.
- `-c source_path destination_path` copies a file specified in `source_path` to `destination_path`.  
e.g.: `lk.sh -c "//<server>/<sharedFolder>/<exampleFile>" "<localFolder>"` copies `<exampleFile>` to the local machine at `<localFolder>`.  
If no `destination_path` is supplied the default is the current directory from which the script is run.
- `-d` runs a user-configurable default behavior.  
This currently is set to navigate to a path within a file with filename "networkLocation".

### tf.sh
tf.sh transfer copies of local files to a default remote network location, the path for which must be stored as a string within environmental variable `$transferFolder`.
> USAGE: `tf.sh source_file [target_subdirectory]`
> - e.g.: `tf.sh filename subdirectory` copes file `filename` to `$transferFolder/subdirectory`
> - `source_file` is the local file to be copied to `$transferFolder`
> - `target_subdirectory` is an optional argument that enables copying to a subdirectory within `$transferFolder`.
> - NOTE: `$transferFolder` must omit the `smb://` from the network path to the desired default remote location.

### up.sh
Enables easy navigation 'up' a path.
> Usage: `. up.sh [n]`
> - `. up.sh` moves up one directory level
> - `. up.sh n` moves up n directories
> - NOTE: This file must be SOURCED, i.e. use: `.` before `up.sh`  
For convenience, consider placing a suitable alias in bash_profile, e.g.: `alias up= ". up.sh"`




