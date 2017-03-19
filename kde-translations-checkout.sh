#!/bin/bash

#Avtor: Andrej Mernik, 2016-2017, https://andrej.mernik.eu/
#Licenca: GPLv3

# osnovna mapa
svn checkout --depth empty svn+ssh://svn@svn.kde.org/home/kde/ svn
svn update --set-depth empty svn/trunk
svn update --set-depth empty svn/branches
svn update --set-depth empty svn/branches/stable

# predloge za KDE4 trunk
svn update --set-depth empty svn/trunk/l10n-kde4
svn update --set-depth empty svn/trunk/l10n-kde4/templates
svn update --set-depth infinity svn/trunk/l10n-kde4/templates/messages

# prevodi za KDE4 trunk
svn update --set-depth empty svn/trunk/l10n-kde4/sl
svn update --set-depth infinity svn/trunk/l10n-kde4/sl/messages

# predloge za KDE4 stable
svn update --set-depth empty svn/branches/stable/l10n-kde4
svn update --set-depth empty svn/branches/stable/l10n-kde4/templates
svn update --set-depth infinity svn/branches/stable/l10n-kde4/templates/messages

# prevodi za KDE4 stable
svn update --set-depth empty svn/branches/stable/l10n-kde4/sl
svn update --set-depth infinity svn/branches/stable/l10n-kde4/sl/messages

# predloge za KF5 trunk
svn update --set-depth empty svn/trunk/l10n-kf5
svn update --set-depth empty svn/trunk/l10n-kf5/templates
svn update --set-depth infinity svn/trunk/l10n-kf5/templates/messages

# prevodi za KF5 trunk
svn update --set-depth empty svn/trunk/l10n-kf5/sl
svn update --set-depth infinity svn/trunk/l10n-kf5/sl/messages

# predloge za KF5 stable
svn update --set-depth empty svn/branches/stable/l10n-kf5
svn update --set-depth empty svn/branches/stable/l10n-kf5/templates
svn update --set-depth infinity svn/branches/stable/l10n-kf5/templates/messages

# prevodi za KF5 stable
svn update --set-depth empty svn/branches/stable/l10n-kf5/sl
svn update --set-depth infinity svn/branches/stable/l10n-kf5/sl/messages
