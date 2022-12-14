# TwpFastApp

`TwpFastApp` is a microservice-ready monolith application.

This application is created using [Zaruba](https://github.com/state-alchemists/zaruba). To create the application, you can invoke:

```bash
zaruba please initProject # or cd to your zaruba project
zaruba please addFastApp appDirectory=twpFastApp

# zaruba please start
```

# 🏁 How to start

You can run `twpFastApp` by invoking:

```bash
zaruba please startTwpFastApp
```

Alternatively, you can also invoke the following script:

```bash
cd twpFastApp

# create virtual environment if not exist
if [ ! -d ./venv ]; then python -m venv ./venv; fi

# activate virtual environment
source venv/bin/activate

# install pip packages
pip install -r requirements.txt

# load environments
source template.env

# run the application
./start.sh
```

# ☑️ Prerequisites

- Python 3.9
- Pip
- Virtual env

# 📖 Documentation

Please visit TwpFastApp documentation [here](_docs/README.md).