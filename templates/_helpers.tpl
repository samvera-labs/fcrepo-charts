{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fcrepo.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fcrepo.fullname" }}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fcrepo.chart" }}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fcrepo.labels" }}
helm.sh/chart: {{ include "fcrepo.chart" . }}
{{ include "fcrepo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fcrepo.selectorLabels" }}
app.kubernetes.io/name: {{ include "fcrepo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "fcrepo.serviceAccountName" }}
{{- if .Values.serviceAccount.create }}
{{- default (include "fcrepo.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "fcrepo.postgresql.fullname" }}
{{- $name := default "postgresql" .Values.postgresql.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return PostgreSQL host
*/}}
{{- define "fcrepo.postgresql.host" }}
{{- if not .Values.postgresql.enabled }}
    {{- .Values.postgresql.postgresqlHost }}
{- else }}
    {{- include "fcrepo.postgresql.fullname" . }}
{{- end }}

{{/*
Return PostgreSQL username
*/}}
{{- define "fcrepo.postgresql.username" }}
{{- if .Values.global.postgresql.postgresqlUsername }}
     {{- .Values.global.postgresql.postgresqlUsername }}
{{- else }}
     {{- .Values.postgresql.postgresqlUsername }}
{{- end }}
{{- end }}

{{/*
Return PostgreSQL password
*/}}
{{- define "fcrepo.postgresql.password" }}
{{- if .Values.global.postgresql.postgresqlPassword }}
    {{- .Values.global.postgresql.postgresqlPassword }}
{{- else if .Values.postgresql.postgresqlPassword }}
    {{- .Values.postgresql.postgresqlPassword }}
{{- else }}
    {{- randAlphaNum 10 }}
{{- end }}
{{- end }}
