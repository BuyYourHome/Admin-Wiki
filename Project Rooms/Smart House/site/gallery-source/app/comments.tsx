'use client';
import { useEffect, useRef, useState, type FormEvent } from 'react';

type Comment = {id:string;page:string;name:string;body:string;createdAt:number};
type CommentPage = {comments:Comment[];nextCursor:string|null;error?:string};

export default function Comments({page,title,onAsk}:{page:string;title:string;onAsk:()=>void}) {
  const [comments,setComments] = useState<Comment[]>([]);
  const [cursor,setCursor] = useState<string|null>(null);
  const [loading,setLoading] = useState(true);
  const [failed,setFailed] = useState(false);
  const [loadingMore,setLoadingMore] = useState(false);
  const [saving,setSaving] = useState(false);
  const [name,setName] = useState('');
  const [body,setBody] = useState('');
  const [website,setWebsite] = useState('');
  const [message,setMessage] = useState('');
  const [retry,setRetry] = useState(0);
  const requestId = useRef<string|null>(null);

  useEffect(()=>{
    const controller=new AbortController();
    setLoading(true);setFailed(false);
    fetch(`/api/comments?page=${encodeURIComponent(page)}`,{cache:'no-store',signal:controller.signal})
      .then(async response=>{const data=await response.json() as CommentPage;if(!response.ok)throw new Error(data.error);return data;})
      .then(data=>{setComments(data.comments);setCursor(data.nextCursor);})
      .catch(error=>{if(error.name!=='AbortError')setFailed(true);})
      .finally(()=>{if(!controller.signal.aborted)setLoading(false);});
    return ()=>controller.abort();
  },[page,retry]);

  async function loadMore() {
    if(!cursor||loadingMore)return;
    setLoadingMore(true);setMessage('');
    try {
      const response=await fetch(`/api/comments?page=${encodeURIComponent(page)}&cursor=${encodeURIComponent(cursor)}`,{cache:'no-store'});
      const data=await response.json() as CommentPage;
      if(!response.ok)throw new Error(data.error);
      setComments(current=>[...current,...data.comments.filter(item=>!current.some(existing=>existing.id===item.id))]);
      setCursor(data.nextCursor);
    } catch {setMessage('Older comments could not be loaded. Please try again.');}
    finally {setLoadingMore(false);}
  }

  async function submit(event:FormEvent<HTMLFormElement>) {
    event.preventDefault();if(saving||loading||failed||!body.trim())return;
    setSaving(true);setMessage('');
    requestId.current??=crypto.randomUUID();
    try {
      const response=await fetch('/api/comments',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({page,name,body,website,requestId:requestId.current})});
      const data=await response.json() as {comment?:Comment;error?:string};
      if(!response.ok||!data.comment)throw new Error(data.error||'Your comment could not be saved.');
      const saved=data.comment;
      setComments(current=>[saved,...current.filter(item=>item.id!==saved.id)]);
      setBody('');requestId.current=null;setMessage('Your comment is posted. Thanks for being part of Pondster.');
    } catch(error) {setMessage(error instanceof Error?error.message:'Your comment could not be saved. Please try again.');}
    finally {setSaving(false);}
  }

  return <section className="comments-section" aria-labelledby="comments-heading">
    <div className="comments-heading"><div><p className="eyebrow">COMMENTS / {title.toUpperCase()}</p><h2 id="comments-heading">Join the conversation.</h2></div><p>Share your thoughts about {title==='Built By'?'the people behind Pondster':`Pondster’s ${title.toLowerCase()} page`}. For questions, <button className="comments-ask" onClick={onAsk}>ask Pondster ↗</button></p></div>
    <div className="comments-layout">
      <form className="comment-form" onSubmit={submit}>
        <h3>Leave a comment.</h3>
        <p id="comment-public-note">Comments are public. Please leave out the house address, contact details, entry codes, and other private information.</p>
        <label htmlFor="comment-name">Name <span>optional</span></label>
        <input id="comment-name" name="name" autoComplete="nickname" maxLength={60} value={name} onChange={event=>{setName(event.target.value);requestId.current=null;}} disabled={saving} placeholder="Guest"/>
        <label htmlFor="comment-body">Your comment</label>
        <textarea id="comment-body" name="comment" required maxLength={1000} rows={5} value={body} onChange={event=>{setBody(event.target.value);requestId.current=null;}} disabled={saving} aria-describedby="comment-public-note comment-limit" placeholder="What’s on your mind?"/>
        <span id="comment-limit" className="comment-limit">{body.length} / 1,000 characters</span>
        <div className="comment-trap" aria-hidden="true"><label htmlFor="comment-website">Leave this field empty</label><input id="comment-website" name="website" tabIndex={-1} autoComplete="off" value={website} onChange={event=>setWebsite(event.target.value)}/></div>
        <button className="comment-submit" type="submit" disabled={saving||loading||failed||!body.trim()}>{saving?'Posting…':'Post comment'}<span aria-hidden="true">↗</span></button>
        <p className="comment-status" role="status" aria-live="polite">{message}</p>
      </form>
      <div className="comment-conversation" aria-busy={loading||loadingMore}>
        <div className="comment-list-heading"><h3>The conversation</h3><span>NEWEST FIRST</span></div>
        {loading?<p className="comments-empty">Loading comments…</p>:failed?<div className="comments-empty"><p>Comments are unavailable right now.</p><button className="text-button" onClick={()=>setRetry(retry+1)}>Try again</button></div>:comments.length===0?<div className="comments-empty"><span aria-hidden="true">“</span><p>A new conversation starts here.<br/>Be the first to leave a thought.</p></div>:<ol className="comment-list">{comments.map(comment=><li key={comment.id}><article><div><h4>{comment.name}</h4><time dateTime={new Date(comment.createdAt).toISOString()}>{new Date(comment.createdAt).toLocaleDateString('en-US',{month:'short',day:'numeric',year:'numeric'})}</time></div><p>{comment.body}</p></article></li>)}</ol>}
        {!failed&&cursor&&<button className="comments-more" onClick={loadMore} disabled={loadingMore}>{loadingMore?'Loading…':'Load older comments'} <span aria-hidden="true">↓</span></button>}
      </div>
    </div>
  </section>;
}
