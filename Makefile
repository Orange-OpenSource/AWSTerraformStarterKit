name: Build and Push Docker Images

on:
  push:
    branches:
      - '**'
    tags:
      - '**'

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        image: [ TFEnv, TFlint, jinja2, TerraformDocs ]  # Specify the Docker images you want to build

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Get branch or tag name
      id: image_tag
      run: |
        if [[ "${GITHUB_REF}" == "refs/heads/"* ]]; then
          TAG=$(echo ${GITHUB_REF#refs/heads/} | tr '/' '-')
        elif [[ "${GITHUB_REF}" == "refs/tags/"* ]]; then
          TAG=$(echo ${GITHUB_REF#refs/tags/} | tr '/' '-')
        else
          echo "::error::Unable to determine branch or tag name."
          exit 1
        fi
        echo "TAG=$TAG" >> $GITHUB_OUTPUT


    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1

    - name: Login to Amazon ECR
      id: login-ecr
      uses: aws-actions/amazon-ecr-login@v1
      with:
         registry-type:  public

    - name: Build and push Docker images
      env:
        ECR_REGISTRY: "public.ecr.aws/h1a2u4u1"
        IMAGE_TAG: ${{ steps.image_tag.outputs.TAG }}
      run: |
        LOWERCASE_IMAGE_NAME=$(echo ${{ matrix.image }} | tr '[:upper:]' '[:lower:]')
        docker build -t $ECR_REGISTRY/$LOWERCASE_IMAGE_NAME:$IMAGE_TAG ./automation/${{ matrix.image }}/
        docker push $ECR_REGISTRY/$LOWERCASE_IMAGE_NAME:$IMAGE_TAG
