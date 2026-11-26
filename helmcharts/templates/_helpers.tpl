{{- define "common.fullname" -}}
{{ .Values.name }}
{{- end }}

{{- define "common.labels" -}}
app.kubernetes.io/name: {{ include "common.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
