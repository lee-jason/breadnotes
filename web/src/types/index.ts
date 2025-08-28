export interface User {
  id: string;
  email: string;
  name: string;
  profile_picture?: string;
  created_at: string;
}

export interface BreadEntry {
  id: string;
  title: string;
  notes?: string;
  image_url?: string;
  user_id: string;
  created_at: string;
  updated_at?: string;
  user: User;
}

export interface CreateBreadEntryData {
  title: string;
  notes?: string;
  image?: File;
}