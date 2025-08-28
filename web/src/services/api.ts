import axios from 'axios';
import { BreadEntry, CreateBreadEntryData, User } from '../types';

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000';

const api = axios.create({
  baseURL: `${API_BASE_URL}/api`,
  withCredentials: true,
});

export const authService = {
  login: () => {
    window.location.href = `${API_BASE_URL}/api/auth/login`;
  },
  
  logout: async () => {
    await api.get('/auth/logout');
  },
  
  getCurrentUser: async (): Promise<User> => {
    const response = await api.get('/auth/me');
    return response.data;
  },
};

export const breadService = {
  createEntry: async (data: CreateBreadEntryData): Promise<BreadEntry> => {
    const formData = new FormData();
    formData.append('title', data.title);
    if (data.notes) formData.append('notes', data.notes);
    if (data.image) formData.append('image', data.image);
    
    const response = await api.post('/bread-entries/', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    return response.data;
  },
  
  getUserEntries: async (): Promise<BreadEntry[]> => {
    const response = await api.get('/bread-entries/');
    return response.data;
  },
  
  getRecentEntries: async (): Promise<BreadEntry[]> => {
    const response = await api.get('/bread-entries/recent');
    return response.data;
  },
  
  getEntry: async (id: string): Promise<BreadEntry> => {
    const response = await api.get(`/bread-entries/${id}`);
    return response.data;
  },
  
  updateEntry: async (id: string, data: CreateBreadEntryData): Promise<BreadEntry> => {
    const formData = new FormData();
    formData.append('title', data.title);
    if (data.notes) formData.append('notes', data.notes);
    if (data.image) formData.append('image', data.image);
    
    const response = await api.put(`/bread-entries/${id}`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    return response.data;
  },
  
  deleteEntry: async (id: string): Promise<void> => {
    await api.delete(`/bread-entries/${id}`);
  },
};