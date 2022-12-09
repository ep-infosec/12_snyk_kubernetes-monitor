#! /bin/bash
set -e

# $1 is the version from package.json
# if semantic release chooses not to release (only chores for example)
# then it would be null
if [ $1 == "null" ]; then
  echo Semantic-Release did not create a new version, not pushing a new approved image
  ./scripts/slack/notify_success_no_release.py
else
  IMAGE_NAME_CANDIDATE=snyk/kubernetes-monitor:staging-candidate-${CIRCLE_SHA1}
  IMAGE_NAME_APPROVED=snyk/kubernetes-monitor:${1}-approved

  docker pull ${IMAGE_NAME_CANDIDATE}
  docker tag ${IMAGE_NAME_CANDIDATE} ${IMAGE_NAME_APPROVED}
  docker push ${IMAGE_NAME_APPROVED}
  ./scripts/slack/notify_push.py ${IMAGE_NAME_APPROVED}

  IMAGE_NAME_CANDIDATE_UBI8=snyk/kubernetes-monitor:staging-candidate-ubi8-${CIRCLE_SHA1:0:8}
  IMAGE_NAME_APPROVED_UBI8=snyk/kubernetes-monitor:${1}-ubi8-approved

  docker pull ${IMAGE_NAME_CANDIDATE_UBI8}
  docker tag ${IMAGE_NAME_CANDIDATE_UBI8} ${IMAGE_NAME_APPROVED_UBI8}
  docker push ${IMAGE_NAME_APPROVED_UBI8}
  ./scripts/slack/notify_push.py ${IMAGE_NAME_APPROVED_UBI8}
fi
