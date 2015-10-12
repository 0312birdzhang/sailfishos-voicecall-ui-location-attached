#
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.27
#

Name:       sailfishos-voicecall-ui-location-attached

# >> macros
BuildArch: armv7hl
# << macros

Summary:    Jolla Call Regin patch
Version:    0.0.4
Release:    1
Group:      Qt/Qt
License:    GPLV2
Source0:    %{name}-%{version}.tar.bz2
Requires:   patchmanager
Requires:   voicecall-ui-jolla >= 0.8.6.1
%description
Phone location for China,only support phone number now


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre



# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
mkdir -p %{buildroot}/usr/share/patchmanager/patches/sailfishos-voicecall-ui-location-attached
cp -r patch/* %{buildroot}/usr/share/patchmanager/patches/sailfishos-voicecall-ui-location-attached
mkdir -p %{buildroot}/home/nemo/.local/share/JollaMobile/voicecall-ui/QML/OfflineStorage/Databases
cp -r data/* %{buildroot}/home/nemo/.local/share/JollaMobile/voicecall-ui/QML/OfflineStorage/Databases
mkdir -p %{buildroot}/usr/share/voicecall-ui-jolla/common
cp voicecall-ui-jolla/*.js %{buildroot}/usr/share/voicecall-ui-jolla/common
# << install pre

# >> install post
# << install post

%pre
# >> pre
if [ -f /usr/sbin/patchmanager ]; then
/usr/sbin/patchmanager -u sailfishos-voicecall-ui-location-attached || true
fi
# << pre

%preun
# >> preun
if [ -f /usr/sbin/patchmanager ]; then
/usr/sbin/patchmanager -u sailfishos-voicecall-ui-location-attached|| true
fi
# << preun

%files
%defattr(-,root,root,-)
%{_datadir}/patchmanager/patches/sailfishos-voicecall-ui-location-attached
%{_datadir}/voicecall-ui-jolla/common
/home/nemo/.local/share/JollaMobile/voicecall-ui/QML/OfflineStorage/Databases
# >> files
# << files
