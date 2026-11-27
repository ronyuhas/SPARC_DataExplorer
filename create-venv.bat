@echo ON
REM Base the environment name off of the parent folder name.
for /f %%q in ("%~dp0.") do set "env_prefix=%%~nxq"
cd "%~dp0."
echo %env_prefix%

REM Construct the virtual environment name with parent folder name
set "venv_name=%env_prefix%_env"

REM Check if virtual environment already exists
if exist "%venv_name%\scripts\activate" (
  echo Virtual environment '%venv_name%' already exists. Activating...
  goto ACTIVATE
)

REM Create the virtual environment
echo Creating virtual environment '%venv_name%'...
python -m venv "%venv_name%"
echo Virtual environment created successfully!

:ACTIVATE
echo Activating virtual environment...
call "%venv_name%\scripts\activate"


python -m pip install --upgrade pip

pip install jupyterlab ipykernel
REM pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
IF EXIST "requirements.txt" (python -m pip install -r requirements.txt)

ipython kernel install --user --name=%venv_name%

IF NOT EXIST 'Notebooks' (mkdir Notebooks)

cd Notebooks

python -m jupyterlab
:END
@ECHO OFF