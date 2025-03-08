module MLCanopyVarCtl

  !-----------------------------------------------------------------------
  ! !DESCRIPTION:
  ! Module containing multilayer canopy model run control variables
  !
  ! !USES:

  use shr_kind_mod, only : r8 => shr_kind_r8
  use shr_sys_mod,  only : shr_sys_abort
  
  !
  ! !PUBLIC TYPES:
  implicit none

  ! Model run options

  character(len=6) :: clm_phys = 'CLM4_5' ! Snow/soil layers differ for CLM4.5 and CLM5. Options: 'CLM4_5' or 'CLM5_0'
  integer  :: gs_type = 2                 ! Stomatal conductance: Medlyn (0), Ball-Berry (1), or WUE optimization (2)
  integer  :: gspot_type = 1              ! Stomatal conductance: use potential conductance (0) or water-stressed conductance (1)
  integer  :: colim_type = 1              ! Photosynthesis: minimum rate (0) or co-limited rate (1)
  integer  :: acclim_type = 1             ! Photosynthesis: temperature acclimation off (0) or on (1)
  real(r8) :: kn_val = -999._r8           ! Canopy nitrogen profile: for a user-specified Kn, set kn_val to desired value > 0
  integer  :: turb_type = 1               ! Turbulence parameterization: dataset (-1) or well-mixed assumption (0) or H&F roughness sublayer (1)
  integer  :: gb_type = 3                 ! Boundary layer cond.: CLM5 (0) or laminar only (1) or also turbulent (2) and free convection (3)
  integer  :: light_type = 2              ! Solar radiative transfer: Norman (1) or two-stream approximation (2)
  integer  :: longwave_type = 1           ! Longwave radiative transfer: Norman (1)
  integer  :: fpi_type = 2                ! Fraction of precipitation intercepted: CLM4.5 (1) or CLM5 (2)
  integer  :: root_type = 2               ! Root profile: CLM4.5 (1) uses Zeng2001 or CLM5 (2) uses Jackson1996
  real(r8) :: fracdir = -999._r8          ! Fraction of solar radiation that is direct beam (used if fracdir >= 0)
  integer  :: mlcan_to_clm = 0            ! Pass multilayer canopy fluxes to CLM for use by CAM: no (0), yes (1)
  integer  :: ml_vert_init = ispval       ! Flag used to initialize multilayer canopy vertical structure and profiles

  ! Use dz_tall or dz_short to determine the number of canopy layers ...

  real(r8) :: dz_tall = 0.5_r8            ! Height increment for tall canopies > dz_param (m)
  real(r8) :: dz_short = 0.1_r8           ! Height increment for short canopies <= dz_param (m)
  real(r8) :: dz_param = 2._r8            ! Height above which a canopy is tall (m)
  real(r8) :: dpai_min = 0.01_r8          ! Minimum plant area index to be considered a vegetation layer (m2/m2)

  ! ... or directly specify the number of layers (used if these are > 0)

  integer  :: nlayer_above = 0            ! The number of above-canopy layers
  integer  :: nlayer_within = 0           ! The number of within-canopy layers

  ! Archival or permanent disk full pathname for RSL psihat look-up tables

  character(len=256), save :: rslfile = '../rsl_lookup_tables/psihat.nc'

  ! Model sub-timestep (s) is 5 minutes

  real(r8), save :: dtime_substep = 5._r8 * 60._r8

contains
  
  subroutine endrun(msg) 
    
    !-----------------------------------------------------------------------
    ! !DESCRIPTION:
    ! Abort the model for abnormal termination
    ! This subroutine was derived from CLM's
    ! endrun_vanilla() in abortutils.F90
    !
    !
    ! !ARGUMENTS:
    implicit none
    character(len=*), intent(in) :: msg    ! string to be printed
    !-----------------------------------------------------------------------
    
    write(log_unit,*)'ML-ENDRUN:', msg
    call shr_sys_abort()
    
  end subroutine endrun
    
end module MLCanopyVarCtl
