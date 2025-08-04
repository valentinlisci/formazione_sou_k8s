{{/*
Return the full name of the release
*/}}
{{- define "flask-chart.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the name of the chart
*/}}
{{- define "flask-chart.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{/*
Return the chart version
*/}}
{{- define "flask-chart.chart" -}}
{{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end -}}

