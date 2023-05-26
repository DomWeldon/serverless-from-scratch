FROM public.ecr.aws/lambda/python:3.10

# copy app directory into lambda task root
COPY app ${LAMBDA_TASK_ROOT}/app
COPY pyproject.toml ${LAMBDA_TASK_ROOT}
COPY pdm.lock ${LAMBDA_TASK_ROOT}

RUN pip install pdm
RUN pdm export -o requirements.txt
RUN pip install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"