# SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
#
# SPDX-License-Identifier: MIT
#

%undefine _hardened_build
%define _gprdir %_GNAT_project_dir
%define rtl_version 0.1

Name:       webidl
Version:    0.1.0
Release:    git%{?dist}
Summary:    A WebIDL parser in Ada
Group:      Development/Libraries
License:    MIT
URL:        https://github.com/reznikmm/anagram
### Direct download is not availeble
Source0:    webidl.tar.gz
BuildRequires:   gcc-gnat
BuildRequires:   fedora-gnat-project-common  >= 3 
BuildRequires:   matreshka-devel
BuildRequires:   gprbuild

# gprbuild only available on these:
ExclusiveArch: %GPRbuild_arches

%description
A WebIDL parser in Ada.

%package devel

Group:      Development/Libraries
License:    MIT
Summary:    Devel package for Ada Pretty
Requires:       %{name}%{?_isa} = %{version}-%{release}
Requires:   fedora-gnat-project-common  >= 2

%description devel
Devel package for webidl

%prep 
%setup -q -n %{name}

%build
make  %{?_smp_mflags} GPRBUILD_FLAGS="%Gnatmake_optflags"

%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot} LIBDIR=%{_libdir} PREFIX=%{_prefix} GPRDIR=%{_gprdir} BINDIR=%{_bindir}

%check
make  %{?_smp_mflags} GPRBUILD_FLAGS="%Gnatmake_optflags" check

%post     -p /sbin/ldconfig
%postun   -p /sbin/ldconfig

%files
%{_bindir}/webidl-run
%doc LICENSES/MIT.txt
%files devel
%doc README.md
%{_includedir}/%{name}
%{_gprdir}/webidl.gpr
%{_gprdir}/manifests/webidl


%changelog
* Sun Feb 07 2021 Max Reznik <reznikmm@gmail.com> - 0.1.0-git
- Initial package
