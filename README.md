# SplitFiles
Simple program for splitting large text files (eg. logs) into smaller chunks

### Regular usage ###
**Usage:** `./split_files.rb directory_path max_size(optional) log_dir(optional) result_path(optional)`

**Options:**
- `directory_path` - directory with files to be processed
- `max_size` - maximum file size of output file - files are processed line by line rather than byte by byte, so actual size of output files may exceed this value
- `log_dir` - directory, where application log files are to be stored
- `result_path` - path, where result files are to be saved

If `max_size` is not specified, default value of 10 MB is used.

If `log_dir` is not specified, program stores log files in directory path stored in `LOG_PATH` environmental variable.
If that variable is not set, log files are being stored in the directory of the script.

If `result_path` is not specified, the result files are stored in directory specified by `directory_path`.

### Docker usage ###

#### With git repository ####
```bash
git clone https://github.com/Forinil/split_files.git
cd split_files
docker build -t split_files .
docker run -it --rm split_files directory_path max_size(optional) log_dir(optional) result_path(optional)
```

#### With docker repository ####
[Docker Hub repository](https://hub.docker.com/r/forinil/split_files/)
```bash
docker pull forinil/split_files
docker tag forinil/split_files split_files
docker run -it --rm split_files directory_path max_size(optional) log_dir(optional) result_path(optional)
```

Of course there is no need to tag docker repository image with shorter name before using it, it is simply 
more convenient for repeated use.

If you want to access application log files after running docker image, you must mount a host directory to one inside the container 
and point the application to it by either specifying `log_dir` parameter or `LOG_PATH` variable (especially if you wish to avoid specifying
regular expression as well).

For example:
```bash
docker run -it --rm -v `$(pwd)`:/logs -e LOG_PATH=/logs split_files directory_path
```