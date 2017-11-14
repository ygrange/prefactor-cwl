cwlVersion: v1.0
class: CommandLineTool

baseCommand: python

hints:
  DockerRequirement:
      dockerImageId: kernsuite/prefactor
      dockerFile: |
        FROM kernsuite/base:3
        RUN docker-apt-install prefactor

requirements:
  - class: InlineJavascriptRequirement
  - class: EnvVarRequirement
    envDef:
      PYTHONPATH: /usr/lib/prefactor/scripts/

inputs:
  ms:
    type: Directory

  DirSkymodelCal:
    type: string
    default: /usr/share/prefactor/skymodels/

  extensionSky:
    type: string
    default: ".skymodel"

arguments:
  - prefix: -c
    valueFrom: |
      from find_skymodel_cal import main
      from shutil import copyfile
      from os import path
      DirSkymodelCal="$(inputs.DirSkymodelCal)"
      SkymodelCal = main(ms_input="$(inputs.ms.path)",
           DirSkymodelCal=DirSkymodelCal,
           extensionSky="$(inputs.extensionSky)",
      )['SkymodelCal']
      copyfile(path.join(DirSkymodelCal, SkymodelCal), "selected.skymodel")

outputs:
   skymodel:
     type: File
     outputBinding:
       glob: "selected.skymodel"


$namespaces:
  s: http://schema.org/
$schemas:
  - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://mit-license.org/"
s:author:
  s:person.url: "http://orcid.org/0000-0002-6136-3724"
