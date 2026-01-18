<template>
  <div class="memo-container">
    <div class="section-header">
      <h3 class="section-title">Staff Memos</h3>
      <button 
        v-if="jobStore.userInfo.isBoss" 
        class="action-btn primary" 
        @click="handleCreateMemo"
      >
        <span>✍️ New Memo</span>
      </button>
    </div>
    
    <div v-if="jobStore.jobData.memos.length === 0" class="empty-state">
      <p>{{ jobStore.userInfo.isBoss ? 'No memos yet. Create one to communicate with your staff.' : 'No memos from management yet.' }}</p>
    </div>
    
    <div v-else class="memo-list">
      <div 
        v-for="(memo, index) in sortedMemos" 
        :key="index"
        class="memo-card"
        :class="{ pinned: memo.pinned }"
      >
        <div class="memo-header">
          <div class="memo-meta">
            <span v-if="memo.pinned" class="pin-badge">📌 Pinned</span>
            <span class="memo-date">{{ formatDate(memo.date) }}</span>
          </div>
          <div v-if="jobStore.userInfo.isBoss" class="memo-actions">
            <button 
              class="icon-btn" 
              @click="handleTogglePin(index)"
              :title="memo.pinned ? 'Unpin' : 'Pin'"
            >
              {{ memo.pinned ? '📍' : '📌' }}
            </button>
            <button 
              class="icon-btn danger" 
              @click="handleDeleteMemo(index)"
              title="Delete"
            >
              🗑️
            </button>
          </div>
        </div>
        
        <div class="memo-content">
          <h4 v-if="memo.title" class="memo-title">{{ memo.title }}</h4>
          <p class="memo-text">{{ memo.content }}</p>
        </div>
        
        <div v-if="memo.author" class="memo-footer">
          <span class="memo-author">— {{ memo.author }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useJobStore } from '../../stores/job'
import { sendNuiMessage } from '../../utils/nui'

const jobStore = useJobStore()

const sortedMemos = computed(() => {
  // Sort memos: pinned first, then by date (newest first)
  return [...jobStore.jobData.memos].sort((a, b) => {
    if (a.pinned && !b.pinned) return -1
    if (!a.pinned && b.pinned) return 1
    return new Date(b.date) - new Date(a.date)
  })
})

function formatDate(timestamp) {
  if (!timestamp) return 'Unknown'
  const date = new Date(timestamp)
  const now = new Date()
  const diff = now - date
  const days = Math.floor(diff / (1000 * 60 * 60 * 24))
  
  if (days === 0) {
    return 'Today at ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
  } else if (days === 1) {
    return 'Yesterday at ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
  } else if (days < 7) {
    return `${days} days ago`
  } else {
    return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
  }
}

function handleCreateMemo() {
  sendNuiMessage('NUI:Client:JobCreateMemo', {
    jobName: jobStore.jobData.name
  })
}

function handleTogglePin(index) {
  const actualIndex = jobStore.jobData.memos.findIndex(m => m === sortedMemos.value[index])
  sendNuiMessage('NUI:Client:JobTogglePinMemo', {
    jobName: jobStore.jobData.name,
    index: actualIndex
  })
}

function handleDeleteMemo(index) {
  const actualIndex = jobStore.jobData.memos.findIndex(m => m === sortedMemos.value[index])
  if (confirm('Delete this memo?')) {
    sendNuiMessage('NUI:Client:JobDeleteMemo', {
      jobName: jobStore.jobData.name,
      index: actualIndex
    })
  }
}
</script>

<style scoped>
.memo-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 12px;
}

.section-title {
  font-size: 18px;
  font-weight: 700;
  color: white;
  margin: 0;
}

.action-btn {
  padding: 10px 16px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
  font-weight: 600;
}

.action-btn.primary {
  background: rgba(66, 135, 245, 0.2);
  border: 1px solid rgba(66, 135, 245, 0.4);
  color: #4287f5;
}

.action-btn.primary:hover {
  background: rgba(66, 135, 245, 0.3);
  border-color: rgba(66, 135, 245, 0.6);
  transform: translateY(-1px);
}

.empty-state {
  padding: 40px 20px;
  text-align: center;
  background: rgba(26, 26, 26, 0.5);
  border: 1px dashed rgba(255, 255, 255, 0.2);
  border-radius: 8px;
}

.empty-state p {
  margin: 0;
  color: rgba(255, 255, 255, 0.5);
  font-style: italic;
}

.memo-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.memo-card {
  padding: 20px;
  background: rgba(26, 26, 26, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-left: 3px solid rgba(66, 135, 245, 0.5);
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  transition: all 0.2s;
}

.memo-card.pinned {
  background: rgba(66, 135, 245, 0.05);
  border-left-color: #4287f5;
  border-left-width: 4px;
}

.memo-card:hover {
  background: rgba(26, 26, 26, 0.7);
  border-color: rgba(255, 255, 255, 0.2);
}

.memo-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.memo-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
}

.pin-badge {
  font-size: 12px;
  padding: 4px 8px;
  background: rgba(66, 135, 245, 0.2);
  border: 1px solid rgba(66, 135, 245, 0.4);
  border-radius: 4px;
  color: #4287f5;
  font-weight: 600;
}

.memo-date {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
}

.memo-actions {
  display: flex;
  gap: 8px;
}

.icon-btn {
  width: 32px;
  height: 32px;
  border: none;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.icon-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: scale(1.05);
}

.icon-btn.danger:hover {
  background: rgba(255, 59, 48, 0.2);
}

.memo-content {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.memo-title {
  font-size: 16px;
  font-weight: 700;
  color: white;
  margin: 0;
}

.memo-text {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.6;
  margin: 0;
  white-space: pre-wrap;
}

.memo-footer {
  padding-top: 8px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.memo-author {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.6);
  font-style: italic;
}

/* Responsive Design */
@media (max-width: 600px) {
  .memo-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .memo-actions {
    align-self: flex-end;
  }
}
</style>
