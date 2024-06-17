# For your convenience 
alias PlistBuddy=/usr/libexec/PlistBuddy
cp PetImager/exportOptionsTemplate.plist PetImager/exportOptionsTemplate_temp.plist

PLIST="PetImager/exportOptionsTemplate_temp.plist"
PlistBuddy -c "set :destination export" $PLIST
PlistBuddy -c "set :method development" $PLIST
PlistBuddy -c "set :signingStyle manual" $PLIST
PlistBuddy -c "set :teamID D85QWSUNYA" $PLIST
PlistBuddy -c "set :signingCertificate 'iPhone Developer: Anton Babko (T22B63323S)'" $PLIST
PlistBuddy -c "delete :provisioningProfiles:%BUNDLE_ID%" $PLIST
PlistBuddy -c "add :provisioningProfiles:ua.edu.ukma.apple-env.babko.CatsAndModules string 3a8dcb5e-4149-46c2-8623-2a6cbc1d0459" $PLIST

# IMPLEMENT:
# Read script input parameter and add it to your Info.plist. Values can either be CATS or DOGS
ARG=$1

INFO_PLIST="PetImager/CatsAndModules_AntonBabko/CatsAndModules_AntonBabko/Info.plist"
PlistBuddy -c "add :PetType string $ARG" $INFO_PLIST

# IMPLEMENT:
WORKSPACE=PetImager/CatsAndModules_AntonBabko.xcworkspace # без пробілів!
SCHEME="CatsAndModules_AntonBabko"
CONFIG=Debug
DEST="generic/platform=iOS"
VERSION="v1.0.0"
ARCHIVE_PATH="./ARCHIVES/${VERSION}.xcarchive"

# Clean build folder
xcodebuild clean -workspace "${WORKSPACE}" -scheme "${SCHEME}" -configuration "${CONFIG}"

# IMPLEMENT:
# Create archive
xcodebuild archive \
-archivePath "${ARCHIVE_PATH}" \
-workspace "${WORKSPACE}" \
-scheme "${SCHEME}" \
-configuration "${CONFIG}" \
-destination "${DEST}"

# IMPLEMENT:
# Export archive
EXPORT_PATH="./Exported_$ARG"
# виконати збірку для конкретних параметрів
xcodebuild -exportArchive \
-archivePath "${ARCHIVE_PATH}" \
-exportPath "${EXPORT_PATH}" \
-exportOptionsPlist "${PLIST}" # обовʼязково!
