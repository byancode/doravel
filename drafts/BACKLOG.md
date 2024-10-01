# 📝 Backlog del Proyecto: [Nombre del Proyecto]

**Descripción**:
_Lista de todas las tareas, características y mejoras planificadas para el proyecto. Aquí se detallan los elementos pendientes de desarrollo, priorizados según su importancia y urgencia._

---

## 📌 Estructura del Backlog

### 🟢 Epics
_Estructuras principales que agrupan un conjunto de características y funcionalidades del proyecto._

- [ ] **E-01**: Gestión de Usuarios
  _Funcionalidades relacionadas con la creación, autenticación y autorización de usuarios._

- [ ] **E-02**: Gestión de Tareas
  _Módulo para la creación y administración de tareas personales._

- [ ] **E-03**: Notificaciones y Alertas
  _Sistema de alertas para eventos importantes dentro de la aplicación._

---

## 🔵 Historias de Usuario
_Historias que definen qué quiere lograr el usuario con cada funcionalidad._

- [x] **[US-001]** Como usuario, quiero poder crear una cuenta con mi correo electrónico, para iniciar sesión y usar la aplicación.
- [ ] **[US-002]** Como usuario, quiero recibir un correo de verificación al registrarme, para confirmar mi dirección de correo y asegurar la seguridad de mi cuenta.
- [ ] **[US-003]** Como usuario, quiero poder restablecer mi contraseña en caso de olvido, para recuperar el acceso a mi cuenta.
    _Comentario: Falta definir si es por correo o por SMS._

- [ ] **[US-004]** Como usuario, quiero poder crear nuevas tareas y asignarles una prioridad, para organizar mejor mis pendientes.
- [ ] **[US-005]** Como usuario, quiero poder marcar una tarea como completada, para ver mi progreso en la lista de tareas.
- [?] **[US-006]** Como usuario, quiero recibir una notificación por correo cuando una tarea está próxima a vencer, para recordarme de completar la tarea a tiempo.
    _Comentario: Verificar integración con API de notificaciones._

---

## 🟡 Tareas Técnicas
_Tareas de carácter técnico que no son directamente visibles para el usuario, pero son necesarias para el desarrollo del proyecto._

- [x] **TT-001**: Configurar la base de datos y crear la estructura de tablas iniciales.
  _Base de datos configurada con las tablas `users`, `tasks`, `notifications`._

- [ ] **TT-002**: Implementar autenticación JWT para las API.
  _Pendiente de revisión de seguridad._

- [x] **TT-003**: Configurar despliegue continuo con GitHub Actions.
  _Pipeline configurado con pruebas automatizadas._

---

## 🔴 Bugs & Issues
_Registro de errores o problemas detectados que requieren solución._

- [ ] **BUG-01**: Error al iniciar sesión con usuarios registrados.
  _Descripción: Los usuarios no pueden iniciar sesión si se registraron con correo y luego actualizaron su contraseña._

- [x] **BUG-02**: El sistema no envía correos de recuperación.
  _Descripción: Los correos de recuperación de contraseña no se envían en algunos casos debido a un problema de configuración de SMTP. Revisar el protocolo utilizado._

---

## 🎯 Definición de Prioridades

- [x] **Alta**: Elementos críticos para el funcionamiento del proyecto. Deben ser atendidos con prioridad.
- [ ] **Media**: Elementos importantes pero no críticos. Se deben resolver después de los de alta prioridad.
- [ ] **Baja**: Elementos que no son urgentes ni críticos, pero agregan valor al proyecto a largo plazo.

---

## 🔄 Flujo de Trabajo
1. [ ] **Backlog**: Tareas y funcionalidades en lista de espera.
2. [ ] **To Do**: Tareas que se han priorizado y están listas para ser trabajadas.
3. [ ] **In Progress**: Tareas en proceso de desarrollo.
4. [ ] **Review**: Tareas completadas que están en revisión.
5. [ ] **Completed**: Tareas finalizadas y revisadas.
6. [ ] **Blocked**: Tareas que no pueden avanzar debido a dependencias o problemas externos.

---

## 📋 Definición de Estados

- [ ] **To Do**: Tareas pendientes de comenzar.
- [x] **In Progress**: Tareas actualmente en desarrollo.
- [ ] **Review**: Tareas terminadas que están siendo revisadas.
- [x] **Completed**: Tareas completadas y aprobadas.
- [x] **Blocked**: Tareas bloqueadas por alguna razón.

---

## ✍️ Notas Adicionales
- _Añadir cualquier comentario adicional relevante para la gestión del backlog._

